defmodule PhoenixDown do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(PhoenixDown.PostServer, [])
    ]

    opts = [strategy: :one_for_one, name: PhoenixDown.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
