defmodule EventPlatformWeb.EventView do
  use EventPlatformWeb, :view
  alias EventPlatformWeb.{EventView, UserView}
  @invitation_status_code %{"cancelled" => 2, "accepted" => 3}
  def render("ok.json", _) do
    :ok
  end

  def render("index_event_details.json", %{events: events}) do
    %{data: render_many(events, EventView, "event_details.json")}
  end

  def render("index.json", %{events: events}) do
    sorted_events = events |> Enum.sort_by(& &1.start_time, {:asc, NaiveDateTime})
    %{data: render_many(sorted_events, EventView, "event.json")}
  end

  def render("calender.json", %{events: events}) do
    events
    |> Enum.filter(&(NaiveDateTime.compare(&1.start_time, NaiveDateTime.utc_now()) in [:gt, :eq]))

    render("index.json", %{events: events})
  end

  def render("show.json", %{event: event}) do
    %{data: render_one(event, EventView, "event.json")}
  end

  def render("show_event_details.json", %{event: event}) do
    %{data: render_one(event, EventView, "event_details.json")}
  end

  def render("event_details.json", %{event: event}) do
    render(EventView, "event.json", event: event)
    |> Map.merge(%{
      invitaiton_count: Enum.count(event.invites),
      invitation_accepted:
        Enum.count(event.invites, &(&1.status == Map.get(@invitation_status_code, "accepted"))),
      invitation_cancelled:
        Enum.count(event.invites, &(&1.status == Map.get(@invitation_status_code, "cancelled")))
    })
  end

  def render("event.json", %{event: event}) do
    %{
      id: event.id,
      title: event.title,
      description: event.description,
      type: event.type,
      start_time: NaiveDateTime.to_string(event.start_time),
      end_time: NaiveDateTime.to_string(event.end_time),
      duration: get_duration(event.end_time, event.start_time),
      location: event.location,
      host: render_one(event.host, UserView, "user.json"),
      host_id: event.host_id
    }
  end

  @one_minute 60
  @one_hour 3600
  defp get_duration(end_time, start_time) do
    diff = NaiveDateTime.diff(end_time, start_time)

    hh = diff |> div(@one_hour)
    mm = diff |> rem(@one_hour) |> div(@one_minute) |> add_padding
    sec = diff |> rem(@one_hour) |> rem(@one_minute) |> add_padding

    "#{hh}:#{mm}:#{sec}"
  end

  defp add_padding(int) do
    int |> Integer.to_string() |> String.pad_leading(2, "0")
  end
end
