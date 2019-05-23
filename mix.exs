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
      {:benchee, "~> 1.0.1", only: :dev},
      {:crimpex, git: "https://github.com/bbc-news/Crimpex.git"},
      {:distillery, "~> 2.0"},
      {:ex_aws, "~> 2.0"},
      {:ex_aws_lambda, "~> 2.0"},
      {:ex_aws_sts, "~> 2.0"},
      {:ex_metrics, git: "https://github.com/bbc/ExMetrics.git"},
      {:logger_file_backend, "~> 0.0.10"},
      {:mock, "~> 0.3", only: :test},
      {:mojito, "~> 0.3.0"},
      {:mox, "~> 0.5", only: :test},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 3.1"},
      {:stump, "~> 1.0"},
      {:sweet_xml, "~> 0.6"}
    ]
  end
end
