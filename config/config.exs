# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :event_platform,
  ecto_repos: [EventPlatform.Repo]

# Configures the endpoint
config :event_platform, EventPlatformWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "u54bRH5KwDVPgS4kI7b+8UCgoN6KFt2L4pa8V0bf2v9M91QhdQaYBhzOtELE+RsA",
  render_errors: [view: EventPlatformWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: EventPlatform.PubSub,
  live_view: [signing_salt: "jsXA7O6G"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :event_platform, EventPlatformWeb.AuthenticationHelper,
       issuer: "event_platform",
       secret_key: "u54bRH5KwDVPgS4kI7pa8V0bf2v9M91QhdQaYBhzOtELE"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
