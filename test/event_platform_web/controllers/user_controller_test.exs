defmodule EventPlatformWeb.UserControllerTest do
  use EventPlatformWeb.ConnCase

  @valid_attrs %{
    date_of_birth: ~D[2010-04-17],
    email: "some@email.com",
    first_name: "some first_name",
    gender: "some gender",
    last_name: "some last_name",
    password: "Password1"
  }
  @invalid_attrs %{
    date_of_birth: "",
    email: "",
    first_name: "",
    gender: "",
    last_name: "",
    password: "123"
  }

  setup %{conn: conn} do
    conn = add_authentication_token(conn)
    {:ok, conn: conn}
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      first_name = Map.get(@valid_attrs, :first_name)

      last_name = Map.get(@valid_attrs, :last_name)

      conn = post conn, Routes.user_path(conn, :signup), user: @valid_attrs

      assert %{
               "id" => id,
               "first_name" => ^first_name,
               "last_name" => ^last_name
             } = json_response(conn, 201)["data"]

      refute is_nil(id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, Routes.user_path(conn, :signup), user: @invalid_attrs

      assert %{
               "email" => ["can't be blank"],
               "first_name" => ["can't be blank"],
               "last_name" => ["can't be blank"],
               "password" => [
                 "must include at least 1 alphabetic character",
                 "should be at least 4 character(s)"
               ]
             } == json_response(conn, 422)
    end
  end

  describe "Get user" do
    setup do
      user = insert(:user)

      {:ok, user: user}
    end

    test "get all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :list))

      assert is_list(json_response(conn, 200)["data"])
    end

    test "get user when id is valid", %{conn: conn, user: %{id: user_id}} do
      conn = get(conn, Routes.user_path(conn, :index, user_id))

      assert %{"id" => ^user_id} = json_response(conn, 200)["data"]
    end

    test "get user when id is invalid", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index, 20))

      assert %{"error" => "Resource not found"} = json_response(conn, 404)
    end
  end

  describe "Tests for user topics" do
    setup do
      user = insert(:user)
      topic_of_interest = insert(:topic_of_interest)

      {:ok, user: user, topic_of_interest: topic_of_interest}
    end

    test "Adding topics for the user", %{
      conn: conn,
      user: user,
      topic_of_interest: %{id: topic_of_interest_id}
    } do
      conn =
        post(conn, Routes.user_path(conn, :add_user_topic, user.id),
          topic_of_interest_id: topic_of_interest_id
        )

      assert %{"topics_of_interests" => [%{"id" => ^topic_of_interest_id}]} =
               json_response(conn, 200)["data"]
    end

    test "Adding Invalid topic for the user", %{
      conn: conn,
      user: user,
      topic_of_interest: %{id: topic_of_interest_id}
    } do
      conn =
        post(conn, Routes.user_path(conn, :add_user_topic, user.id),
          topic_of_interest_id: topic_of_interest_id + 2
        )

      assert %{"error" => "Resource not found"} = json_response(conn, 404)
    end

    test "Deleting topic of the user", %{
      conn: conn,
      user: user,
      topic_of_interest: %{id: topic_of_interest_id}
    } do
      EventPlatform.UserManagement.update_user_with_topics_of_interest(
        user.id,
        topic_of_interest_id
      )

      conn =
        delete(conn, Routes.user_path(conn, :remove_user_topic, user.id, topic_of_interest_id))

      assert "ok" = json_response(conn, 200)

      assert [] ==
               EventPlatform.UserManagement.get_user_with_topics_of_interests(user.id).topics_of_interests
    end
  end

  defp add_authentication_token(conn) do
    user = insert(:user)
    {:ok, token} = EventPlatformWeb.AuthenticationHelper.create_token(user)

    conn |> put_req_header("authorization", "Bearer #{token}")
  end
end
