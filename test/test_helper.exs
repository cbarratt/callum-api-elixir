ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Callum.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Callum.Repo --quiet)
Ecto.Adapters.SQL.Sandbox.mode(Callum.Repo, :manual)

{:ok, _} = Application.ensure_all_started(:ex_machina)
