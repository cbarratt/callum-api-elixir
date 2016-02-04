use Mix.Config

# Configures the endpoint
config :callumapi, Callumapi.Endpoint,
  url: [host: "localhost"],
  root: Path.expand("..", __DIR__),
  secret_key_base: "IGJNjwde2o+mgsVy0N1bxcc9C+joKls3pKA6sZD+MCk12AEMVTTAyjKPd8YCQfWp",
  debug_errors: false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
