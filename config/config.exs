use Mix.Config

config :callum, ecto_repos: [Callum.Repo]

config :callum, Callum.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "r0A2kfTFbhTZKsBxxZAqm7kElVHL7GqK9eDDqtAT3yXrdoIHwQNt2dGbMH+pPxrq",
  render_errors: [accepts: ~w(html json)],
  pubsub: [
    name: Callum.PubSub,
    adapter: Phoenix.PubSub.PG2
  ]

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

import_config "#{Mix.env}.exs"

config :phoenix, :generators,
  migration: true,
  binary_id: false
