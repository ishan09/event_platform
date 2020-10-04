defmodule EventPlatformWeb.UserView do
  use EventPlatformWeb, :view
  alias EventPlatformWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      gender: user.gender,
      role: user.role,
      topics_of_interests:
        if is_list(user.topics_of_interests) do
          render_many(user.topics_of_interests, "topic_of_interest.json", as: :topic_of_interest)
        else
          []
        end
    }
  end

  def render("topics_of_interests.json", %{topics_of_interests: topics_of_interests}) do
    %{
      data:
        render_many(topics_of_interests, UserView, "topic_of_interest.json",
          as: :topic_of_interest
        )
    }
  end

  def render("topic_of_interest.json", %{topic_of_interest: topic_of_interest}) do
    %{id: topic_of_interest.id, title: topic_of_interest.title}
  end
end
