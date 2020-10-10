defmodule EventPlatformWeb.UserView do
  use EventPlatformWeb, :view
  alias EventPlatformWeb.UserView
  alias EventPlatform.UserManagement.User

  def render("ok.json", _) do
    :ok
  end

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user_with_topics.json")}
  end

  def render("show.json", %{user: %User{} = user}) do
    %{data: render_one(user, UserView, "user_with_topics.json")}
  end

  def render("show.json", _) do
    nil
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      gender: user.gender,
      role: user.role,
    }
  end
  
  def render("user_with_topics.json", %{user: user}) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      gender: user.gender,
      role: user.role,
      topics_of_interests: render_topics_of_interests(user.topics_of_interests)
    }
  end
  

  defp render_topics_of_interests(topics_of_interests) when is_list(topics_of_interests) do
    render(EventPlatformWeb.TopicOfInterestView, "index.json",
      topics_of_interests: topics_of_interests
    ).data
  end

  defp render_topics_of_interests(_), do: []
end
