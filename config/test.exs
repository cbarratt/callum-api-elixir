use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :callumapi, Callumapi.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

if System.get_env("CIRCLECI") do
  config :callumapi, Callumapi.Repo,
    adapter: Ecto.Adapters.Postgres,
    url: {:system, "DATABASE_URL"}
else
  config :callumapi, Callumapi.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: "callum",
    password: "",
    database: "callumapi_test",
    size: 1,
    max_overflow: false,
    pool: Ecto.Adapters.SQL.Sandbox
end
