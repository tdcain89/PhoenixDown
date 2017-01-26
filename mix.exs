defmodule PhoenixDown.Mixfile do
  use Mix.Project

  def project do
    [app: :phoenix_down,
     version: "0.0.1",
     elixir: "~> 1.4.1",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {PhoenixDown, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger, :gettext, :calendar]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.1"},
     {:phoenix_html, "~> 2.9.2"},
     {:phoenix_live_reload, "~> 1.0.7", only: :dev},
     {:gettext, "~> 0.13.0"},
     {:cowboy, "~> 1.0.4"},
     {:earmark, "~> 1.1.0" },
     {:calendar, "~> 0.17.1"}
   ]
  end
end
