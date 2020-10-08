defmodule EventPlatformWeb.Plugs.VerifyRole do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    with %{role: role} = claims <- Guardian.Plug.current_resource(conn),
         {:has_role, true} <- {:has_role, Enum.member?(opts, role)} do
      assign(conn, :user, claims)
    else
      _ -> conn |> send_resp(401, "unauthorized") |> halt()
    end
  end
end
