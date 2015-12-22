# Personal site implemented in Elixir & Phoenix

## Requirements

- Erlang/OTP 18
- PostgreSQL

To start the Phoenix application:

1. Install dependencies with `mix deps.get`
2. Run Ecto database creation with `mix ecto.create`
3. Run Ecto migrations with `mix ecto.migrate`
4. Pull MyFitnessPal and Withings data with `MFP_USER=xxx MFP_PASS=xxx mix api.pulldata`
5. Start Phoenix endpoint with `mix phoenix.server`

Now you can visit `localhost:4000` from your browser.
