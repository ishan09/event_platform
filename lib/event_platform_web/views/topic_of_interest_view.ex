defmodule EventPlatformWeb.TopicOfInterestView do
  use EventPlatformWeb, :view
  alias EventPlatformWeb.TopicOfInterestView

  def render("index.json", %{topics_of_interests: topics_of_interests}) do
    %{data: render_many(topics_of_interests, TopicOfInterestView, "topic_of_interest.json")}
  end

  def render("show.json", %{topic_of_interest: topic_of_interest}) do
    %{data: render_one(topic_of_interest, TopicOfInterestView, "topic_of_interest.json")}
  end

  def render("topic_of_interest.json", %{topic_of_interest: topic_of_interest}) do
    %{id: topic_of_interest.id, title: topic_of_interest.title}
  end
end
