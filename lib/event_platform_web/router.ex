defmodule EventPlatformWeb.Router do
  use EventPlatformWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :verify do
    plug EventPlatformWeb.Plugs.VerifyUser
  end

  pipeline :verify_admin do
    plug EventPlatformWeb.Plugs.VerifyRole, ["admin"]
  end

  pipeline :verify_member do
    plug EventPlatformWeb.Plugs.VerifyRole, ["member"]
  end

  scope "/", EventPlatformWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", EventPlatformWeb do
    pipe_through :api

    post "/signup", UserController, :signup
    post "/login", LoginController, :login

    pipe_through(:verify)

    get "/topics", TopicOfInterestController, :list
    get "/users", UserController, :list
    get "/users/:user_id", UserController, :index
    get "/users/:user_id/topics", TopicOfInterestController, :user_topics
    post "/users/:user_id/topics", UserController, :add_user_topic
    delete "/users/:user_id/topics/:topic_of_interest_id", UserController, :remove_user_topic
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: EventPlatformWeb.Telemetry
    end
  end
end
