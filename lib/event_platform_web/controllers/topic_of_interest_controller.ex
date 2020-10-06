defmodule EventPlatformWeb.TopicOfInterestController do
  use EventPlatformWeb, :controller

  alias EventPlatform.UserManagement
  alias EventPlatform.UserManagement.User

  action_fallback EventPlatformWeb.FallbackController

  def list(conn, _params) do
    topics_of_interests = UserManagement.list_topics_of_interests()
  
    conn
    |> render("index.json", topics_of_interests: topics_of_interests)
  end

  def user_topics(conn, %{"user_id" => user_id}) do
    with %User{} = user <- UserManagement.get_user_with_topics_of_interests(user_id) do
      conn
      |> render("index.json", topics_of_interests: user.topics_of_interests)
    else
      _ ->
        {:error, :not_found}
    end
    
  end
end
