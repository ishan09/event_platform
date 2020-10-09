defmodule EventPlatformWeb.EventController do
  use EventPlatformWeb, :controller

  alias EventPlatform.EventManagement
  alias EventPlatform.EventManagement.Event

  action_fallback EventPlatformWeb.FallbackController

  def index(conn, _params) do
    events = EventManagement.list_events()
    render(conn, "index.json", events: events)
  end

  def create(conn, %{"event" => event_params}) do
    with {:ok, %Event{} = event} <- EventManagement.create_event(event_params) do
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
    event = EventManagement.get_event(id) |> IO.inspect(label: "event found--->>>")

    with {:ok, %Event{}} <- EventManagement.delete_event(event) do
      send_resp(conn, :no_content, "")
    end
  end


    
end
