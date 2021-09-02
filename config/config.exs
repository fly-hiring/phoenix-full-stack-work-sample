# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# config :fly,
#   ecto_repos: [Fly.Repo]

# Configures the endpoint
config :fly, FlyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "g0wCHzb5BTTt3VfdPbF+oy5AefmaRILAyUBbuEuQP+EmVsGIxYhOkdUN1qzEl8I8",
  render_errors: [view: FlyWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Fly.PubSub,
  live_view: [signing_salt: "xRInS97h"],
  static_url: [path: "/phx"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# don't log passwords or tokens
config :phoenix, :filter_parameters, ["password", "auth_token", "token"]

config :fly, :graphql_endpoint, "https://api.fly.io/graphql"

config :fly, :client_api, Fly.ClientLive

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
