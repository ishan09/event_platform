defmodule EventPlatformWeb.PageController do
  use EventPlatformWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
