defmodule Ingress.MixProject do
  use Mix.Project

  def project do
    [
      app: :ingress,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Ingress.Application, []}
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
      {:invoke_lambda, git: "https://github.com/james-bowers/elixir-invoke-lambda.git"},
      {:mock, "~> 0.3", only: :test},
      {:distillery, "~> 2.0"}
    ]
  end
end
