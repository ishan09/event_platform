defmodule EventPlatform.AuthenticationHelperTest do
  use EventPlatform.DataCase

  describe "test token creation and verification" do
    alias EventPlatformWeb.AuthenticationHelper

    setup do
      {
        :ok,
        user: insert(:user)
      }
    end

    test "Generate access token", %{user: user} do
      assert {:ok, _} = AuthenticationHelper.create_token(user)
    end
  end
end
