defmodule EventPlatform.EventManagement do
  @moduledoc """
  The EventManagement context.
  """

  import Ecto.Query, warn: false
  alias EventPlatform.Repo

  alias EventPlatform.EventManagement.{Event, Invite}

  @doc """
  Returns the list of events.

  ## Examples

      iex> list_events()
      [%Event{}, ...]

  """
  def list_events do
    Event
    |> preload([:invites, :host])
    |> Repo.all()
  end

  @doc """
  Returns the list of events for a User Id

  ## Examples

      iex> list_events(user_id)
      [%Event{}, ...]

  """
  def list_events(user_id) do
    user_id
    |> user_events_query
    |> preload(:host)
    |> Repo.all()
  end

  @doc """
  Returns the list of events a User with given status

  ## Examples

      iex> list_events(user_id, "accepted")
      [%Event{}, ...]

  """
  def list_events(user_id, status) do
    status_code = Invite.get_status_code(status)

    user_id
    |> user_events_query()
    |> preload(:host)
    |> where([e, i], i.status == ^status_code)
    |> Repo.all()
  end

  @doc """
  Gets a single event.

  Returns nil if the Event does not exist.

  ## Examples

      iex> get_event(123)
      %Event{}

      iex> get_event(456)
      nil

  """
  def get_event(id), do: Repo.get(Event, id) |> preload_event_host

  @doc """
    Gets a single event with invites.

    Returns nil if the Event does not exist.

    ## Examples

      iex> get_event(123)
      %Event{}

      iex> get_event(456)
      nil

  """
  def get_event_with_invites(id) do
    id
    |> get_event()
    |> Repo.preload(:invites)
  end

  @doc """
  Creates an event.

  ## Examples

      iex> create_event(%{field: value})
      {:ok, %Event{}}

      iex> create_event(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

      iex> create_event(%{field: bad_date_format})
      {:error, %{}}

  """
  def create_event(attrs \\ %{}) do
    attrs
    |> keys_to_atom
    |> validate_dates([:end_date, :start_date])
    |> case do
      {:ok, attrs} ->
        %Event{}
        |> Event.changeset(attrs)
        |> Repo.insert()
        |> preload_event_host()

      {:error, errors} ->
        {:error, errors}
    end
  end

  @doc """
  Updates a event.

  ## Examples

      iex> update_event(event, %{field: new_value})
      {:ok, %Event{}}

      iex> update_event(event, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_event(%Event{} = event, attrs) do
    attrs
    |> keys_to_atom
    |> validate_dates([:end_date, :start_date])
    |> case do
      {:ok, attrs} ->
        event
        |> Event.update_changeset(attrs)
        |> Repo.update()

      {:error, errors} ->
        {:error, errors}
    end
  end

  @doc """
  Deletes a event.

  ## Examples

      iex> delete_event(event)
      {:ok, %Event{}}

      iex> delete_event(event)
      {:error, %Ecto.Changeset{}}

  """
  def delete_event(%Event{} = event) do
    Repo.delete(event)
  end

  # ------------------------------------------------

  @doc """
  Returns the list of invites.

  ## Examples

      iex> list_invites()
      [%Invite{}, ...]

  """

  def list_invites(event_id),
    do:
      Invite
      |> where([i], i.event_id == ^event_id)
      |> preload(:invitee)
      |> Repo.all()

  def list_invites(event_id, status) do
    case Invite.get_status_code(status) do
      nil ->
        {:error, :not_found}

      status_code ->
        from(i in Invite, where: i.event_id == ^event_id and i.status == ^status_code)
        |> preload(:invitee)
        |> Repo.all()
    end
  end

  @doc """
    Update the status of invite to member for an event

    rsvp can be yes or no
  """

  def update_invite(event_id, user_id, rsvp) do
    with %Invite{} = invite <- get_invite(event_id, user_id) do
      invite
      |> Invite.changeset(%{status: Invite.transform_rsvp(rsvp)})
      |> Repo.update()
    else
      _ ->
        {:error, :not_found}
    end
  end

  def add_invitees(event_id, user_ids) do
    result =
      user_ids
      |> Enum.reduce({[], []}, fn user_id, {invites, errors} ->
        case insert_invite(event_id, user_id) do
          {:ok, invite} ->
            {[invite | invites], errors}

          {:error, error} ->
            {invites, [error | errors]}
        end
      end)

    {:ok, result}
  end

  defp insert_invite(event_id, user_id) do
    %Invite{}
    |> Invite.changeset(%{user_id: user_id, event_id: event_id, status: 1})
    |> Repo.insert()
  end

  @doc """
    Get invite for an event for a user
  """
  defp get_invite(event_id, user_id) do
    Invite
    |> where([i], i.event_id == ^event_id and i.user_id == ^user_id)
    |> Repo.one()
  end

  defp user_events_query(user_id) do
    from(e in Event,
      join: i in Invite,
      on: e.id == i.event_id,
      where: i.user_id == ^user_id
    )
  end

  defp preload_event_host({:ok, event}) do
    {:ok, event |> Repo.preload(:host)}
  end

  defp preload_event_host(%Event{} = event) do
    event |> Repo.preload(:host)
  end

  defp preload_event_host(event), do: event

  @doc """
  Validates the map for date format in given keys

  If map has empty value for the given key, it ignores it

  ##Returns 
    {:ok, map} 
    {:error, %{message: string, keys: [key]}}

  """

  defp validate_dates(map, keys) do
    vaidation_errors =
      keys
      |> Enum.reduce([], fn key, errors ->
        map
        |> Map.get(key, "")
        |> case do
          "" ->
            errors

          datetime ->
            datetime
            |> NaiveDateTime.from_iso8601()
            |> case do
              {:ok, _} ->
                errors

              {:error, _} ->
                [key | errors]
            end
        end
      end)

    case vaidation_errors do
      [] ->
        {:ok, map}

      _ ->
        {:error,
         %{message: "Datetime should be of format yyyy-mm-dd hh:mm:ss", keys: vaidation_errors}}
    end
  end

  @doc """
  Converts the keys of map to atom if it keys are string

  """

  defp keys_to_atom(map) do
    map
    |> Enum.reduce(%{}, fn {k, v}, result ->
      if is_binary(k) do
        result |> Map.put(String.to_atom(k), v)
      else
        result |> Map.put(k, v)
      end
    end)
  end
end
