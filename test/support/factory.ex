defmodule EventPlatform.Factory do
  @moduledoc """
  Factory for generating test data.
  """
  use ExMachina.Ecto, repo: EventPlatform.Repo
  use Plug.Test

  alias EventPlatform.UserManagement.{User, TopicOfInterest}

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
end
