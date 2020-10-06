defmodule EventPlatformWeb.TopicOfInterestControllerTest do
  use EventPlatformWeb.ConnCase

  setup %{conn: conn} do
    conn = add_authentication_token(conn)
    {:ok, conn: conn}
  end

  describe "list topics of interest" do
    setup do
      topic_1 = insert(:topic_of_interest)
      topic_2 = insert(:topic_of_interest)

      {:ok, topics_of_interests: [topic_1, topic_2]}
    end

    test "renders user when data is valid", %{
      conn: conn,
      topics_of_interests: [%{id: topic1_id}, %{id: topic2_id}]
    } do
      conn = get(conn, Routes.topic_of_interest_path(conn, :list))

      assert [%{"id" => ^topic1_id}, %{"id" => ^topic2_id}] = json_response(conn, 200)["data"]
    end

    test "renders user topics", %{
      conn: conn,
      topics_of_interests: [%{id: topic1_id}, %{id: topic2_id}]
    } do
      conn = get(conn, Routes.topic_of_interest_path(conn, :list))

      assert [%{"id" => ^topic1_id}, %{"id" => ^topic2_id}] = json_response(conn, 200)["data"]
    end
  end

  defp add_authentication_token(conn) do
    user = insert(:user)
    {:ok, token} = EventPlatformWeb.AuthenticationHelper.create_token(user)

    conn |> put_req_header("authorization", "Bearer #{token}")
  end
end
