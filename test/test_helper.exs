ExUnit.start

Mix.Task.run "ecto.create", ~w(-r PhoenixDown.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r PhoenixDown.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(PhoenixDown.Repo)

