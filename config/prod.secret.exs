use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :callumapi, Callumapi.Endpoint,
  secret_key_base: "fQYN0e9SQJXXDXDlwtvVOC9OfEg+mxFYJpaUlT/NK4+vQ/14Pmiod978p9MA0ZRo"

# Configure your database
config :callumapi, Callumapi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "callumapi_prod"
