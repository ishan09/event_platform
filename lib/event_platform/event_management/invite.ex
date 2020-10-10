defmodule EventPlatform.EventManagement.Invite do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventPlatform.EventManagement.{Event,Invite}
  alias EventPlatform.UserManagement.User
  alias Ecto.Multi
  @status %{1 => "invited", 2 => "cancelled", 3 => "accepted"}
  @rsvp %{"no" => 2, "yes" => 3 }

  schema "invites" do
    field :status, :integer
    field :event_id, :id
    field :user_id, :id
    belongs_to(:invitee, User, foreign_key: :user_id, references: :id, define_field: false)
    belongs_to(:event, Event, foreign_key: :event_id, references: :id, define_field: false)
    timestamps()
  end

  # TODO: Add unique constraint for event_id and user_id

  @doc false
  def changeset(invite, attrs) do
    invite
    |> cast(attrs, [:status, :event_id, :user_id])
    |> validate_required([:status, :event_id, :user_id])
    |> update_change(:status, &transform_rsvp/1)
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

  def get_status_code(status) do
    @status |> Enum.find({nil, nil}, fn{_code,value} -> status == value end) |> elem(0)
  end

  def transform_rsvp(rsvp) do
    @rsvp |> Map.get(rsvp, 1)
  end
end
