defmodule EventPlatform.EventManagement.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias EventPlatform.UserManagement.User
  alias EventPlatform.EventManagement.Event

  schema "events" do
    field :title, :string
    field :description, :string
    field :start_time, :naive_datetime
    field :end_time, :naive_datetime
    field :location, :string
    field :type, :string

    timestamps()

    belongs_to(:host, User, foreign_key: :host_id, references: :id)
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:title, :description, :type, :start_time, :end_time, :location])
    |> validate_required([:title, :description, :type, :start_time, :end_time, :location])
  end
end
