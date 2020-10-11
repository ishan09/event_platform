defmodule EventPlatformWeb.EventController do
  use EventPlatformWeb, :controller

  alias EventPlatform.EventManagement
  alias EventPlatform.EventManagement.Event

  action_fallback EventPlatformWeb.FallbackController

  def index(%{assigns: %{user: %{role: "admin"}}} = conn, _params) do
    events = EventManagement.list_events()
    render(conn, "index_event_details.json", events: events)
  end

  def index(%{assigns: %{user: %{id: user_id, role: "member"}}} = conn, _params) do
    events = EventManagement.list_events(user_id)
    render(conn, "index.json", events: events)
  end

  def calender(conn, _params) do
    user_id = conn.assigns.user.id
    events = EventManagement.list_events(user_id, "accepted")
    render(conn, "calender.json", events: events)
  end

  def create(conn, %{"event" => event_params}) do
    user_id = conn.assigns.user.id

    with {:ok, %Event{} = event} <-
           EventManagement.create_event(event_params |> Map.put(:host_id, user_id)) do
      conn
      |> put_status(:created)
      |> render("show.json", event: event)
    end
  end

  def show(conn, %{"id" => id}) do
    with %Event{} = event <- EventManagement.get_event_with_invites(id) do
      render(conn, "event_details.json", event: event)
    else
      _ ->
        {:error, :not_found}
    end
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = EventManagement.get_event(id)

    with {:ok, %Event{} = event} <- EventManagement.update_event(event, event_params) do
      render(conn, "show.json", event: event)
    end
  end

  def delete(conn, %{"id" => id}) do
    with {:get_event, %Event{} = event} <- {:get_event, EventManagement.get_event(id)},
         {:ok, %Event{}} <- EventManagement.delete_event(event) do
      send_resp(conn, :no_content, "")
    else
      {:get_event, _} ->
        {:error, :not_found}

      error ->
        error
    end
  end
end
