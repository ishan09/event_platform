defmodule EventPlatformWeb.EventView do
  use EventPlatformWeb, :view
  alias EventPlatformWeb.{EventView, UserView}

  def render("ok.json", _) do
    :ok
  end

  def render("index_event_details.json", %{events: events}) do
    %{data: render_many(events, EventView, "event_details.json")}
  end

  def render("index.json", %{events: events}) do
    %{data: render_many(events, EventView, "event.json")}
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, EventView, "event.json")}
  end

  def render("event_details.json", %{event: event}) do
      if event != nil do
        render(EventView, "event.json", event: event)
        |> Map.merge(%{
          invitaiton_count: Enum.count(event.invites),
          invitation_accepted: Enum.count(event.invites, &(&1.status == 1)),
          invitation_cancelled: Enum.count(event.invites, &(&1.status == 2))
        })
      end
  end

  def render("event.json", %{event: event}) do
    %{
      id: event.id,
      title: event.title,
      description: event.description,
      type: event.type,
      start_time: event.start_time,
      end_time: event.end_time,
      location: event.location,
      host: render_one(event.host, UserView, "user.json"),
      host_id: event.host_id
    }
  end
end
