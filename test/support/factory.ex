defmodule EventPlatform.Factory do
  @moduledoc """
  Factory for generating test data.
  """
  use ExMachina.Ecto, repo: EventPlatform.Repo
  use Plug.Test

  alias EventPlatform.UserManagement.{User, TopicOfInterest}
  alias EventPlatform.EventManagement.{Event, Invite}

  def user_factory do
    %User{
      first_name: sequence("First_Name "),
      last_name: sequence("Last_Name "),
      email: sequence(:email, &"email-#{&1}@example.com"),
      date_of_birth: ~D[1990-11-01],
      gender: sequence(:role, ["male", "female"]),
      password: "Abc123"
    }
  end

  def topic_of_interest_factory do
    %TopicOfInterest{title: sequence("Topic ")}
  end

  def event_factory do
    %Event{
      title: sequence("Topic "),
      description: sequence("Description "),
      start_time: ~N[2020-01-01 12:00:07],
      end_time: ~N[2020-01-01 13:00:07],
      location: sequence("Location "),
      type: sequence("Type ")
    }
  end

  def invite_factory do
    %Invite{
      status: 1
    }
  end
end
