defmodule Callumapi.Mixfile do
  use Mix.Project

  def project do
    [app: :callumapi,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {Callumapi, []},
     applications: [:phoenix, :cowboy, :logger, :phoenix_ecto, :httpoison, :tzdata]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:phoenix, "~> 1.0.2"},
      {:phoenix_ecto, "~> 1.2.0"},
      {:phoenix_html, "~> 2.2.0"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:postgrex, "~> 0.10"},
      {:cowboy, "~> 1.0"},
      {:calecto, "~> 0.4.0"},
      {:remodel, "~> 0.0.1"},
      {:httpoison, "~> 0.7"},
      {:timex, "~> 0.19.2"}
    ]
  end
end
