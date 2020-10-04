defmodule EventPlatformWeb.LoginController do
  use EventPlatformWeb, :controller

  alias EventPlatform.UserManagement
  alias EventPlatformWeb.AuthenticationHelper

  def login(conn, %{"username" => email, "password" => password} = params) do
    case {String.trim(email), String.trim(password)} do
      {"", ""} ->
        send_unauthorized(conn, "Username and password is required.")

      {"", _} ->
        send_unauthorized(conn, "Username is required.")

      {_, ""} ->
        send_unauthorized(conn, "Password is required.")

      {trimmed_email, trimmed_password} ->
        with {:ok, user} <- UserManagement.authenticate(trimmed_email, trimmed_password),
        {:ok, token} <- AuthenticationHelper.create_token(user) do
          render(conn, "ok.json", data: %{access_token: token})
        else
            _ -> 
                send_unauthorized(conn, "Username or password is incorrect.")
            
            
        end
    end
  end

  defp send_unauthorized(conn, error_message) do
    conn
    |> put_status(:unauthorized)
    |> render("error.json", error: error_message)
  end
end
