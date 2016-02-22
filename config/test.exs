use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :callum, Callum.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
if System.get_env("CIRCLECI") do
  config :callumapi, Callumapi.Repo,
    adapter: Ecto.Adapters.Postgres,
    url: {:system, "DATABASE_URL"},
    pool: Ecto.Adapters.SQL.Sandbox
else
  config :callum, Callum.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: "callum",
    password: "",
    database: "callumapi_test",
    hostname: "localhost",
    pool: Ecto.Adapters.SQL.Sandbox
end
