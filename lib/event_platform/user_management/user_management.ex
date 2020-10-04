defmodule EventPlatform.UserManagement do
  @moduledoc """
  The UserManagement context.
  """

  import Ecto.Query, warn: false

  alias EventPlatform.UserManagement.{User, TopicOfInterest}
  alias EventPlatform.Repo

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Signup a user with role customer

  ## Examples

      iex> signup_user(%{field: value})
      {:ok, %User{}}

      iex> signup_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def signup_user(params) do
    params
    |> add_customer_role()
    |> User.create_user()
    |> Repo.insert()
  end

  @doc """
  Gets a single user with list of topics of interests.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_with_topics_of_interests!(id) do
    id
    |> get_user!
    |> Repo.preload(:topics_of_interests)
  end

  @doc """
  Gets a single topic of interest.

  Raises `Ecto.NoResultsError` if the topic of interest does not exist.

  ## Examples

      iex> get_topic_of_interest!(123)
      %TopicOfInterest{}

      iex> get_topic_of_interest!(456)
      ** (Ecto.NoResultsError)

  """
  def get_topic_of_interest!(id), do: Repo.get!(TopicOfInterest, id)

  @doc """
  Update a single topic of interest for a User.

  Raises `Ecto.NoResultsError` if the Topic of interest or User does not exist.

  ## Examples

      iex> update_user_with_topics_of_interest(123)
      %User{}

      iex> get_topic_of_interest!(456)
      ** (Ecto.NoResultsError)

  """
  def update_user_with_topics_of_interest(id, topic_of_interest_id) do
    topic_of_interest = get_topic_of_interest!(topic_of_interest_id)
    user = get_user_with_topics_of_interests!(id)

    user
    |> User.changeset_user_interests([topic_of_interest | user.topics_of_interests])
    |> Repo.update()
  end

  @doc """
  Remove a single topic of interest from a User.

  ## Examples

      iex> remove_topic_of_interest_from_user(123, 33)
      %User{}

  """
  def remove_topic_of_interest_from_user(id, topic_of_interest_id) do
    user = get_user_with_topics_of_interests!(id)

    updated_topic_of_interest =
      user.topics_of_interests |> Enum.reject(&(&1.id == topic_of_interest_id))

    user
    |> User.changeset_user_interests(updated_topic_of_interest)
    |> Repo.update()
  end

  defp add_customer_role(params) do
    params 
    |> Map.keys()
    |> List.first()
    |> is_atom()
    |> if  do
      Map.put(params, :role, "customer")
    else
      Map.put(params, "role", "customer")
    end
  end
end
