# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :vacancy_api,
  ecto_repos: [VacancyApi.Repo]

# Configures the endpoint
config :vacancy_api, VacancyApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KXDry6XYwGo6QW6aNnoPPe5OIeW1UhI0OoAYlsFzTNxaqFH0io/H1x7+F8H74uFu",
  render_errors: [view: VacancyApiWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: VacancyApi.PubSub, adapter: Phoenix.PubSub.PG2],
  http: [
    protocol_options: [
      max_header_name_length: 8192,
      max_header_value_length: 8192,
      max_headers: 128,
      max_request_line_length: 8192
    ]
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
