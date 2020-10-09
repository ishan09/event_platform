defmodule EventPlatform.EventManagement.Invite do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventPlatform.EventManagement.{Event,Invite}
  alias EventPlatfrom.UserManagement.User
  alias Ecto.Multi
  @status %{1 => "invited", 2 => "rejected", 3 => "accepted"}

  schema "invites" do
    field :status, :integer
    field :event_id, :id
    field :user_id, :id
    belongs_to(:invitee, User, foreign_key: :user_id, references: :id, define_field: false)
    belongs_to(:event, Event, foreign_key: :event_id, references: :id, define_field: false)
    timestamps()
  end

  @doc false
  def changeset(invite, attrs) do
    invite
    |> cast(attrs, [:status, :event_id, :user_id])
    |> validate_required([:status, :event_id, :user_id])
    |> validate_inclusion(:status, Map.keys(@status))
    |> foreign_key_constraint(:event_id)
    |> foreign_key_constraint(:user_id)
  end

  def add_invitees(event_id, user_ids) do
    user_ids
    |> Enum.reduce( Multi.new(), fn user_id, multi ->
      invite_changeset = changeset(%Invite{},%{user_id: user_id, event_id: event_id, status: 1})

      multi |> Multi.insert(user_id, invite_changeset)
    end)
  end
end
