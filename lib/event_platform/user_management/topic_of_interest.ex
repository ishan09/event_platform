defmodule EventPlatform.UserManagement.TopicOfInterest do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventPlatform.UserManagement.TopicOfInterest

  schema "topics_of_interests" do
    field :title, :string

    many_to_many :users, EventPlatform.UserManagement.User,
      join_through: "users_topics_of_interests"

    timestamps()
  end

  @doc false
  def changeset(%TopicOfInterest{} = topic_of_interest, attrs) do
    topic_of_interest
    |> cast(attrs, [:title])
    |> validate_required([:title])
    |> unique_constraint(:title)
  end
end
