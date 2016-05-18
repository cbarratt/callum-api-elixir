use Mix.Config

config :logger, level: :warn

config :callum, Callum.Endpoint,
  http: [port: 4001],
  server: false

if System.get_env("CIRCLECI") do
  config :callum, Callum.Repo,
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
