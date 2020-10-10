defmodule EventPlatformWeb.InviteController do
  use EventPlatformWeb, :controller

  alias EventPlatform.EventManagement
  alias EventPlatform.EventManagement.Event

  action_fallback EventPlatformWeb.FallbackController

  def index(conn, %{"event_id" => event_id, "status" => status}) do
    with invites when is_list(invites) <- EventManagement.list_invites(event_id, status) do
      render(conn, "index_invitees.json", invites: invites)
    else
      error ->
        error
    end
  end

  def index(conn, %{"event_id" => event_id}) do
    with invites when is_list(invites) <- EventManagement.list_invites(event_id) do
      render(conn, "index_invitees.json", invites: invites)
    else
      error ->
        error
    end
  end

  def create(conn, %{"event_id" => event_id, "users" => users}) do
    with {:ok, {invites, _errors}} <- EventManagement.add_invitees(event_id, List.wrap(users)) do
      conn
      |> render("index.json", invites: invites)
    end
  end

end
