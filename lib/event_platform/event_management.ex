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
    Repo.all(Event)
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
  def get_event(id), do: Repo.get(Event, id)

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
        |> Event.changeset(attrs)
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
  def list_invites do
    Repo.all(Invite)
  end

  @doc """
  Creates a invite.

  ## Examples

      iex> create_invite(%{field: value})
      {:ok, %Invite{}}

      iex> create_invite(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_invite(attrs) do
    %Invite{}
    |> Invite.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a invite.

  ## Examples

      iex> delete_invite(invite)
      {:ok, %Invite{}}

      iex> delete_invite(invite)
      {:error, %Ecto.Changeset{}}

  """
  def delete_invite(id) when is_binary(id), do: Invite |> Repo.get(id) |> delete_invite()

  def delete_invite(%Invite{} = invite) do
    Repo.delete(invite)
  end

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
