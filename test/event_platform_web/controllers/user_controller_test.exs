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
end
