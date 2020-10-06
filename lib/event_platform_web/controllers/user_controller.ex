defmodule EventPlatformWeb.UserController do
  use EventPlatformWeb, :controller

  alias EventPlatform.UserManagement
  alias EventPlatform.UserManagement.User

  action_fallback EventPlatformWeb.FallbackController

  def signup(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- UserManagement.signup_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def list(conn, _params) do
    users = UserManagement.list_users()
    conn
    |> render("index.json", users: users)
  end

  def index(conn, %{"user_id" => user_id}) do
    with %User{} = user <- UserManagement.get_user(user_id) do
      conn
      |> render("show.json", user: user)
    else
      _ ->
        {:error, :not_found}
    end
  end

  def add_user_topic(conn, %{"user_id" => user_id, "topic_of_interest_id" => topic_of_interest_id}) do
    with {:ok, user} <-
           UserManagement.update_user_with_topics_of_interest(user_id, topic_of_interest_id) do
      conn
      |> render("show.json", user: user)
    end
  end
end
