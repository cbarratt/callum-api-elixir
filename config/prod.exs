use Mix.Config

config :callumapi, Callumapi.Endpoint,
  http: [port: {:system, "PORT"}],
  url: [host: "example.com"],
  check_origin: false,
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Do not print debug messages in production
config :logger, level: :info

# Configure your database
config :callumapi, Callumapi.Repo,
  adapter: Ecto.Adapters.Postgres,
  url: {:system, "DATABASE_URL"}
