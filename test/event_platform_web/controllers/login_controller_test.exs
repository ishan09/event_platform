defmodule EventPlatformWeb.LoginControllerTest do
  use EventPlatformWeb.ConnCase

  describe "test user login" do
    setup do
      password = "A1234"

      {
        :ok,
        password: password, user: insert(:user, %{password: Bcrypt.hash_pwd_salt(password)})
      }
    end

    test "Successful login", %{conn: conn, user: user, password: password} do
      conn =
        post conn, Routes.login_path(conn, :login), %{username: user.email, password: password}

      assert %{"access_token" => _} = json_response(conn, 200)
    end

    test "Incorrect password while login", %{conn: conn, user: user} do
      conn =
        post conn, Routes.login_path(conn, :login), %{username: user.email, password: "password"}

      assert %{"error" => _} = json_response(conn, 401)
    end

    test "Incorrect username while login", %{conn: conn} do
      conn =
        post conn, Routes.login_path(conn, :login), %{
          username: "some@email.com",
          password: "password"
        }

      assert %{"error" => _} = json_response(conn, 401)
    end
  end
end
