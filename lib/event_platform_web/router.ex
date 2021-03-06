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

  scope "/api", EventPlatformWeb do
    pipe_through :api
    
    pipe_through(:verify)

    scope "/admin" do
      pipe_through(:verify_admin)

      get "/events", EventController, :index
      post "/events", EventController, :create
      get "/events/:id", EventController, :show
      put "/events/:id", EventController, :update
      delete "/events/:id", EventController, :delete

      get "/events/:event_id/invitees", InviteController, :index
      post "/events/:event_id/invitees", InviteController, :create
      
      get "/events/:event_id/invitees/:status", InviteController, :index
      
    end

    scope "/v1", as: :v1 do
      pipe_through(:verify_member)
      get "/my-calendar", EventController, :my_calendar

      get "/events", EventController, :index
      put "/events/:event_id/rsvp", InviteController, :add_rsvp
      get "/events/calender", EventController, :calender
    end
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
