defmodule EventPlatformWeb.AuthenticationHelper do
  use Guardian, otp_app: :event_platform

  import Plug.Conn

  def subject_for_token(user, _claims) do
    {:ok, to_string(user.id)}
  end

  def resource_from_claims(claims) do
    id = claims["sub"]
    resource = EventPlatform.UserManagement.get_user!(id) |> generate_claims()
    {:ok, resource}
  end

  def auth_error(conn, {type, _reason}, _opts) do
    body = Jason.encode!(%{message: to_string(type)})
    send_resp(conn, 401, body)
  end

  @claim_fields ~w(id first_name last_name email role)a

  alias EventPlatform.UserManagement.User

  @doc """
    For creating authentication token for user login
  """

  def create_token(%User{} = login_user) do
    with claims <- generate_claims(login_user),
         {:ok, token, user} <- sign_claims(login_user, claims) do
      {:ok, token}
    end
  end

  defp generate_claims(user) do
    user
    |> Map.from_struct()
    |> Map.take(@claim_fields)
  end

  defp sign_claims(user, claims) do
    encode_and_sign(user, claims,
      token_type: "access",
      ttl: {1, :day}
    )
  end
end
