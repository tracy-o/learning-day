defmodule Ingress.MixProject do
  use Mix.Project

  def project do
    [
      app: :ingress,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Ingress.Application, [env: Mix.env()]}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:plug, "~> 1.7.1"},
      {:cowboy, "~> 2.4"},
      {:plug_cowboy, "~> 2.0"},
      {:httpoison, "~> 1.5"},
      {:poison, "~> 3.1"},
      {:invoke_lambda, git: "https://github.com/bbc/elixir-invoke-lambda.git"},
      {:mock, "~> 0.3", only: :test},
      {:distillery, "~> 2.0"},
      {:mox, "~> 0.5", only: :test},
      {:ex_metrics, git: "https://github.com/bbc/ExMetrics.git"}
    ]
  end
end
