defmodule EventPlatform.UserManagement.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias EventPlatform.UserManagement.User
  @min_password_length 4
  @allowed_roles ~w"admin customer"
  schema "users" do
    field(:first_name, :string)
    field(:last_name, :string)
    field(:email, :string)
    field(:date_of_birth, :date)
    field(:gender, :string)
    field(:role, :string)
    field(:password, :string)

    many_to_many(:topics_of_interests, EventPlatform.UserManagement.TopicOfInterest,
      join_through: "users_topics_of_interests",
      on_replace: :delete
    )

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :email, :role, :date_of_birth, :gender, :password])
    |> validate_required([:first_name, :last_name, :email, :role, :password])
    |> unique_constraint(:email)
    |> validate_inclusion(:role, @allowed_roles)
    |> validate_length(:password, min: @min_password_length)
    |> validate_format(:password, ~r/\d/, message: "must include at least 1 numeric character")
    |> validate_format(:password, ~r/[a-zA-Z]/,
      message: "must include at least 1 alphabetic character"
    )
    |> update_change(:password, &Bcrypt.hash_pwd_salt/1)
  end

  def changeset_user_interests(%User{} = user, topics_of_interests) do
    user
    |> change()
    |> put_assoc(:topics_of_interests, topics_of_interests)
  end

  def create_user(params) do
    %User{}
    |> changeset(params)
  end
end
