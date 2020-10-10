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

  def add_rsvp(conn, %{"event_id" => event_id, "rsvp" => rsvp}) do
    user_id = conn.assigns.user.id

    with {:get_event, %Event{} = event} <- {:get_event, EventManagement.get_event(event_id)},
         {:ok, _invite} <- EventManagement.update_invite(event.id, user_id, rsvp) do
      render(conn, "ok.json")
    else
      {:get_event, _} ->
        {:error, :not_found}

      _ ->
        render(conn, "error.json", error: "Invalid invite response")
    end
  end

end
