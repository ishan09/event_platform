defmodule EventPlatformWeb.FallbackController do
  use EventPlatformWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    errors =
      Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
        Enum.reduce(opts, msg, fn {key, value}, acc ->
          String.replace(acc, "%{#{key}}", to_string(value))
        end)
      end)
      |> Jason.encode!()

    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:unprocessable_entity, errors)
    |> halt
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(EventPlatformWeb.ErrorView)
    |> render("404.json", errors: "not_found")
  end

  def call(conn, error) do
    conn
    |> put_status(500)
    |> render("error.json", errors: :internal_server_error)
  end
end
