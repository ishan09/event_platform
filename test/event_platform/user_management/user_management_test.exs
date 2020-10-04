defmodule EventPlatform.UserManagementTest do
  use EventPlatform.DataCase

  alias EventPlatform.UserManagement

  describe "users" do
    alias EventPlatform.UserManagement.User

    @valid_attrs %{
      date_of_birth: ~D[2010-04-17],
      email: "some@email.com",
      first_name: "some first_name",
      gender: "some gender",
      last_name: "some last_name",
      role: "customer",
      password: "Password1"
    }
    @invalid_attrs %{
      date_of_birth: nil,
      email: nil,
      first_name: nil,
      gender: nil,
      last_name: nil,
      role: nil,
      password: "pas"
    }

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> UserManagement.signup_user()

      user
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert UserManagement.get_user!(user.id) == user
    end

    test "signup_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = UserManagement.signup_user(@valid_attrs)
      assert user.date_of_birth == ~D[2010-04-17]
      assert user.email == "some@email.com"
      assert user.first_name == "some first_name"
      assert user.gender == "some gender"
      assert user.last_name == "some last_name"
      assert user.role == "customer"
    end

    test "signup_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = UserManagement.signup_user(@invalid_attrs)
    end

    test "User changeset/2 for password without numeric character" do
      invalid_params =
        @valid_attrs
        |> Map.put(:password, "abcd")

      assert [
               {:password, {"must include at least 1 numeric character", [validation: :format]}}
             ] == User.changeset(%User{}, invalid_params).errors
    end

    test "User changeset/2 for password without alphabetic character" do
      invalid_params =
        @valid_attrs
        |> Map.put(:password, "12345")

      assert [
               {:password,
                {"must include at least 1 alphabetic character", [validation: :format]}}
             ] == User.changeset(%User{}, invalid_params).errors
    end

    test "User changeset/2 for password with less than requied min charaters" do
      invalid_params =
        @valid_attrs
        |> Map.put(:password, "ab1")

      assert [
               {:password,
                {"should be at least %{count} character(s)",
                 [count: 4, validation: :length, kind: :min, type: :string]}}
             ] == User.changeset(%User{}, invalid_params).errors
    end

    test "User changeset for duplicate emails" do
      user = user_fixture()

      assert {:error, %Ecto.Changeset{}} = UserManagement.signup_user(user |> Map.from_struct())
    end
  end

  describe "test users interests" do
    alias EventPlatform.UserManagement.User

    setup do
      user = insert(:user)
      topic_1 = insert(:topic_of_interest)
      topic_2 = insert(:topic_of_interest)

      {
        :ok,
        user: user, topics_of_interests: [topic_1, topic_2]
      }
    end

    test "add user interest", %{user: user, topics_of_interests: [topic1, _topic2]} do
      assert {:ok, %User{} = updated_user} =
               UserManagement.update_user_with_topics_of_interest(user.id, topic1.id)

      assert updated_user.topics_of_interests == [topic1]
    end

    test "add invalid interest in user", %{user: user, topics_of_interests: [_topic1, topic2]} do
      assert_raise Ecto.NoResultsError, fn ->
        UserManagement.update_user_with_topics_of_interest(user.id, topic2.id + 1)
      end
    end

    test "remove topic of interest from user", %{
      user: user,
      topics_of_interests: [topic1, topic2]
    } do
      UserManagement.update_user_with_topics_of_interest(user.id, topic1.id)
      UserManagement.update_user_with_topics_of_interest(user.id, topic2.id)

      assert {:ok, updated_user} =
               UserManagement.remove_topic_of_interest_from_user(user.id, topic2.id)

      assert updated_user.topics_of_interests == [topic1]
    end
  end
end
