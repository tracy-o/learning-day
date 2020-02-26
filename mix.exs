defmodule Belfrage.MixProject do
  use Mix.Project

  def project do
    [
      app: :belfrage,
      version: "0.1.0",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases()
    ]
  end

  defp elixirc_paths(mix_env) when mix_env in [:test, :end_to_end], do: ["lib", "test/support"]

  defp elixirc_paths(mix_env) when mix_env == :dev,
    do: ["lib", "benchmark", "test/support/fixtures", "test/support/transformer_examples"]

  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      test: ["test --no-start"],
      test_e2e: ["cmd MIX_ENV=end_to_end mix test --color"],
      t: ["format", "cmd mix test --force --color"]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:aws_ex_ray, :logger, :cachex, :os_mon],
      mod: {Belfrage.Application, [env: Mix.env()]}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:uuid, "~> 1.1"},
      {:benchee, "~> 1.0.1", only: :dev},
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:crimpex, git: "https://github.com/bbc-news/Crimpex.git"},
      {:distillery, "~> 2.0"},
      {:eljiffy, "~> 1.3.0"},
      {:ex_aws,
       git: "https://github.com/james-bowers/ex_aws.git", branch: "allowlist-headers-for-signing", override: true},
      {:ex_aws_lambda, git: "https://github.com/james-bowers/ex_aws_lambda.git", branch: "x_ray_trace_id"},
      {:ex_aws_sts, git: "https://github.com/ex-aws/ex_aws_sts.git"},
      {:ex_metrics, git: "https://github.com/bbc/ExMetrics.git"},
      {:aws_ex_ray, "~> 0.1.15"},
      {:logger_file_backend, "~> 0.0.10"},
      {:mock, "~> 0.3", only: :test},
      {:machine_gun, "~> 0.1.6"},
      {:mox, "~> 0.5", only: [:test, :end_to_end]},
      {:plug_cowboy, "~> 2.0"},
      {:stump, "~> 1.6"},
      {:sweet_xml, "~> 0.6"},
      {:cachex, "~> 3.1"},
      {:ets_cleaner, git: "git://github.com/bbc/ets_cleaner.git"},
      {:poison, "~> 3.1"},
      {:secure_random, "~> 0.5.1"}
    ]
  end
end
