defmodule PhoenixDown.Mixfile do
  use Mix.Project

  def project do
    [app: :phoenix_down,
     version: "0.1.0",
     elixir: "~> 1.4.1",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :earmark, :calendar]]
  end

  defp deps do
    [
      {:earmark, "~> 1.1.0" },
      {:calendar, "~> 0.17.1"}
    ]
  end
end
