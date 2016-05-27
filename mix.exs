defmodule Callum.Mixfile do
  use Mix.Project

  def project do
    [
      app: :callum,
      version: "0.0.1",
      elixir: "~> 1.0",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      aliases: aliases,
      deps: deps
    ]
  end

  def application do
    [mod: {Callum, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex, :httpoison]]
  end

  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  defp deps do
    [
      {:phoenix, "~> 1.1.2"},
      {:phoenix_ecto, "~> 3.0.0-beta.2"},
      {:postgrex, "~> 0.11.1"},
      {:phoenix_html, "~> 2.3"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.9"},
      {:httpoison, "~> 0.8.3"},
      {:hackney, "~> 1.6.0", override: true},
      {:timex, "~> 1.0.0"},
      {:cowboy, "~> 1.0"},
      {:ex_machina, "~> 0.6.1", only: :test}
    ]
  end

  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["test --trace"]
    ]
  end
end
