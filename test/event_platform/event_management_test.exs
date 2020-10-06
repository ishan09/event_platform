defmodule EventPlatform.EventManagementTest do
  use EventPlatform.DataCase

  alias EventPlatform.EventManagement
  alias EventPlatform.EventManagement.{Event, Invite}

  describe "events" do
    @valid_attrs %{
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

    def event_fixture() do
      insert(:event, @valid_attrs)
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert EventManagement.list_events() == [event]
    end

    test "get_event/1 returns the event with given id" do
      event = event_fixture()
      assert EventManagement.get_event(event.id) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = EventManagement.create_event(@valid_attrs)
      assert event.description == "some description"
      assert event.end_time == ~N[2010-04-17 14:00:00]
      assert event.location == "some location"
      assert event.start_time == ~N[2010-04-17 14:00:00]
      assert event.title == "some title"
      assert event.type == "some type"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = EventManagement.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, %Event{} = event} = EventManagement.update_event(event, @update_attrs)
      assert event.description == "some updated description"
      assert event.end_time == ~N[2011-05-18 15:01:01]
      assert event.location == "some updated location"
      assert event.start_time == ~N[2011-05-18 15:01:01]
      assert event.title == "some updated title"
      assert event.type == "some updated type"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = EventManagement.update_event(event, @invalid_attrs)
      assert event == EventManagement.get_event(event.id)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = EventManagement.delete_event(event)
      assert is_nil(EventManagement.get_event(event.id))
    end
  end

  describe "invites" do
    setup do
      host = insert(:user)
      event = insert(:event, %{host_id: host.id})

      invitee = insert(:user)

      invite = insert(:invite, %{user_id: invitee.id, event_id: event.id})

      {:ok, host: host, event: event, invite: invite, invitee: invitee}
    end

    test "list all invites", %{invite: invite} do
      assert [^invite] = EventManagement.list_invites()
    end

    test "create invite with valid data", %{event: %{id: event_id}, invitee: %{id: user_id}} do
      assert {:ok, %Invite{}} =
               EventManagement.create_invite(%{user_id: user_id, event_id: event_id, status: 2})
    end

    test "create invite with invalid data", %{} do
      assert {:error, %Ecto.Changeset{}} = EventManagement.create_invite(%{})
    end

    test "delete invite ", %{invite: invite} do 
      assert {:ok, %Invite{}}  = EventManagement.delete_invite(invite)

      assert is_nil(Repo.get(Invite, invite.id))
    end
  end
end
