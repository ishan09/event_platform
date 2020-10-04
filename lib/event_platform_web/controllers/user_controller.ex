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
end
