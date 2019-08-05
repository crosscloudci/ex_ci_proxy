defmodule ExCiProxy.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_ci_proxy,
     version: "0.0.1",
     elixir: "~> 1.9",
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
    [mod: {ExCiProxy, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [{:phoenix, "~> 1.2.5"},
     {:phoenix_pubsub, "~> 1.0"},
     {:phoenix_html, "~> 2.6"},
     {:phoenix_live_reload, "~> 1.0", only: :dev},
     {:gettext, "~> 0.11"},
     {:cowboy, "~> 1.0"},
     {:phoenix_ecto, "~> 3.0"},
     {:postgrex, ">= 0.0.0"},
     {:mix_test_watch, "~> 0.3", only: :dev, runtime: false},
     {:quantum, ">= 2.1.0"},
     {:sidetask, "~> 1.1"},
     {:timex, "~> 3.0"},
     {:timex_ecto, "~> 3.0"},
     {:ecto_conditionals, "~> 0.1.0"},
     {:yaml_elixir, "~> 2.4.0"},
     {:cors_plug, "~> 1.2"},
     {:ex_machina, "~> 2.0"},
     {:gproc, "0.3.1"},
     {:joken, "~> 1.2.1"},
     {:retry, "~> 0.8.0"},
     # {:guardian, "~> 0.12.0"},
     {:export, "~> 0.1.1"}]
  end
end
