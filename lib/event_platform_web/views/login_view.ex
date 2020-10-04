defmodule EventPlatformWeb.LoginView do
  use EventPlatformWeb, :view

  def render("ok.json", %{data: data}) do
    data
  end

  def render("error.json", %{error: error}) do
    %{error: error}
  end
end
