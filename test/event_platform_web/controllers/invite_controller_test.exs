defmodule EventPlatformWeb.InviteControllerTest do
  use EventPlatformWeb.ConnCase

  describe "index" do
    setup [:create_event, :admin_user, :add_authentication_token]

    test "lists all invites", %{conn: conn, event: %{id: event_id}} do
      conn = get(conn, Routes.invite_path(conn, :index, event_id))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create invite" do
    setup [:create_event, :admin_user, :add_authentication_token]

    test "Send invite to user", %{
      conn: conn,
      event: %{id: event_id} = _event,
      user: %{id: user_id} = _user
    } do
      conn = post(conn, Routes.invite_path(conn, :create, event_id), users: [user_id])

      assert [%{"id" => id, "event_id" => ^event_id, "invitee_id" => ^user_id}] =
               json_response(conn, 200)["data"]
    end
  end

  describe "Send RSVP" do
    setup [:member_user, :add_authentication_token, :create_event, :create_invite]

    test "respond rsvp yes", %{conn: conn, event: %{id: event_id}} do
      conn = put(conn, Routes.v1_invite_path(conn, :add_rsvp, event_id), rsvp: "yes")
      assert "ok" = json_response(conn, 200)
    end

    test "Respond invalid rsvp string", %{conn: conn, event: %{id: event_id}} do
      conn = put(conn, Routes.v1_invite_path(conn, :add_rsvp, event_id), rsvp: "invalid")
      assert json_response(conn, 422) == %{"error" => "Invalid invite response"}
    end
  end

  defp create_event(_) do
    event = insert(:event)
    %{event: event}
  end

  defp create_invite(%{event: event, user: user}) do
    invite = insert(:invite, %{event_id: event.id, user_id: user.id})
    %{invite: invite}
  end

  defp admin_user(_) do
    %{user: insert(:user, %{role: "admin"})}
  end

  defp member_user(_) do
    %{user: insert(:user, %{role: "member"})}
  end

  defp add_authentication_token(%{conn: conn, user: user}) do
    {:ok, token} = EventPlatformWeb.AuthenticationHelper.create_token(user)

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> put_req_header("accept", "application/json")

    %{conn: conn}
  end
end
