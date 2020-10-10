defmodule EventPlatform.EventManagement.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Changeset
  alias EventPlatform.UserManagement.User
  alias EventPlatform.EventManagement.{Event, Invite}

  schema "events" do
    field :title, :string
    field :description, :string
    field :start_time, :naive_datetime
    field :end_time, :naive_datetime
    field :location, :string
    field :type, :string

    timestamps()

    belongs_to(:host, User, foreign_key: :host_id, references: :id)

    has_many(:invites, Invite,
      foreign_key: :event_id,
      on_delete: :delete_all
    )

    has_many(:invitees, through: [:invites, :invitee])
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:title, :description, :type, :start_time, :end_time, :location, :host_id])
    |> validate_required([:title, :description, :type, :start_time, :end_time, :location])
    |> validate_date_range()
  end

  def update_changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:title, :description, :type, :start_time, :end_time, :location])
    |> validate_required([:title, :description, :type, :start_time, :end_time, :location])
    |> validate_date_range()
  end

  defp validate_date_range(%Changeset{} = changeset) do
    with %NaiveDateTime{} = start_time <-
           get_field(changeset, :start_time),
         %NaiveDateTime{} = end_time <- get_field(changeset, :end_time),
         :gt <- NaiveDateTime.compare(start_time, end_time) do
      add_error(changeset, :end_time, "Start time should be before End time.")
    else
      _err ->
        changeset
    end
  end
end
