defmodule EventPlatform.UserManagement do
  @moduledoc """
  The UserManagement context.
  """

  import Ecto.Query, warn: false

  alias EventPlatform.UserManagement.{User, TopicOfInterest}
  alias EventPlatform.Repo

  @doc """
  Gets all users.


  ## Examples

      iex> list_users()
      [%User{}]


  """
  def list_users(), do: Repo.all(User)

  @doc """
  Gets a single user.

  Returns nil if the User does not exist.

  ## Examples

      iex> get_user(123)
      %User{}

      iex> get_user(456)
      ** nil

  """
  def get_user(id), do: Repo.get(User, id)

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

      iex> get_user(123)
      %User{}

      iex> get_user(555)
      nil

  """
  def get_user_with_topics_of_interests(id) do
    id
    |> get_user
    |> Repo.preload(:topics_of_interests)
  end

  @doc """
  Gets all topics of interests.


  ## Examples

      iex> list_topics_of_interests()
      [%TopicOfInterest{}]


  """
  def list_topics_of_interests(), do: Repo.all(TopicOfInterest)

  @doc """
  Gets a single topic of interest.

  Returns nil if the topic of interest does not exist.

  ## Examples

      iex> get_topic_of_interest(123)
      {:ok, %TopicOfInterest{}}

      iex> get_topic_of_interest(456)
     nil

  """
  def get_topic_of_interest(id), do: Repo.get(TopicOfInterest, id)

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
    with {:get_topic_of_interest, %TopicOfInterest{} = topic_of_interest} <-
           {:get_topic_of_interest, get_topic_of_interest(topic_of_interest_id)},
         {:get_user_with_topics_of_interests, %User{} = user} <-
           {:get_user_with_topics_of_interests, get_user_with_topics_of_interests(id)} do
      user
      |> User.changeset_user_interests([topic_of_interest | user.topics_of_interests])
      |> Repo.update()
    else
      {:get_topic_of_interest, _} ->
        {:error, :not_found}

      {:get_user_with_topics_of_interests, _} ->
        {:error, :not_found}

      error ->
        error
    end
  end

  @doc """
  Remove a single topic of interest from a User.

  ## Examples

      iex> remove_topic_of_interest_from_user(123, 33)
      %User{}

  """
  def remove_topic_of_interest_from_user(id, topic_of_interest_id) do
    %User{} = user = get_user_with_topics_of_interests(id) 


    updated_topic_of_interest =
      user.topics_of_interests |> Enum.reject(&(&1.id |> to_string == topic_of_interest_id))

    user
    |> User.changeset_user_interests(updated_topic_of_interest)
    |> Repo.update()
  end

  @doc """
  Authenticate user email and password
  """

  def authenticate(email, password) do
    case Repo.get_by(User, email: email) do
      %User{password: hashed_password} = user ->
        if Bcrypt.verify_pass(password, hashed_password) do
          {:ok, user}
        else
          {:error, :unauthorized}
        end

      nil ->
        {:error, :unauthorized}
    end
  end

  defp add_customer_role(params) do
    params
    |> Map.keys()
    |> List.first()
    |> is_atom()
    |> if do
      Map.put(params, :role, "customer")
    else
      Map.put(params, "role", "customer")
    end
  end
end
