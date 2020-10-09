defmodule EventPlatformWeb.EventControllerTest do
  use EventPlatformWeb.ConnCase

  alias EventPlatform.EventManagement.Event

  @create_attrs %{
    description: "some description",
    end_time: ~N[2010-04-17 14:00:00],
    location: "some location",
    start_time: ~N[2010-04-17 14:00:00],
    title: "some title",
    type: "some type"
  }
  @update_attrs %{
    description: "some updated description",
    end_time: ~N[2011-05-18 15:01:01],
    location: "some updated location",
    start_time: ~N[2011-05-18 15:01:01],
    title: "some updated title",
    type: "some updated type"
  }
  @invalid_attrs %{
    description: nil,
    end_time: nil,
    location: nil,
    start_time: nil,
    title: nil,
    type: nil
  }

  setup %{conn: conn} do
    conn =
      conn
      |> put_req_header("accept", "application/json")
      |> add_authentication_token()

    {:ok, conn: conn}
  end

  describe "index" do
    test "lists all events", %{conn: conn} do
      conn = get(conn, Routes.event_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create event" do
    test "renders event when data is valid", %{conn: conn} do
      conn = post(conn, Routes.event_path(conn, :create), event: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.event_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some description",
               "end_time" => "2010-04-17T14:00:00",
               "location" => "some location",
               "start_time" => "2010-04-17T14:00:00",
               "title" => "some title",
               "type" => "some type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.event_path(conn, :create), event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update event" do
    setup [:create_event]

    test "renders event when data is valid", %{conn: conn, event: %Event{id: id} = event} do
      conn = put(conn, Routes.event_path(conn, :update, event), event: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.event_path(conn, :show, id))

      assert %{
               "id" => id,
               "description" => "some updated description",
               "end_time" => "2011-05-18T15:01:01",
               "location" => "some updated location",
               "start_time" => "2011-05-18T15:01:01",
               "title" => "some updated title",
               "type" => "some updated type"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, event: event} do
      conn = put(conn, Routes.event_path(conn, :update, event), event: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete event" do
    setup [:create_event]

    test "deletes chosen event", %{conn: conn, event: event} do
      conn = delete(conn, Routes.event_path(conn, :delete, event))
      assert response(conn, 204)

      assert get(conn, Routes.event_path(conn, :show, event)) |> response(404)
    end
  end

  

  defp create_event(_) do
    event = insert(:event, @create_attrs)
    %{event: event}
  end

 

  defp add_authentication_token(conn) do
    user = insert(:user, %{role: "admin"})
    {:ok, token} = EventPlatformWeb.AuthenticationHelper.create_token(user)

    conn |> put_req_header("authorization", "Bearer #{token}")
  end
end
