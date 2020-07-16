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
      aliases: aliases(),
      test_pattern: test_pattern(Mix.env()),
      warn_test_pattern: test_pattern(Mix.env())
    ]
  end

  defp elixirc_paths(mix_env) when mix_env in [:test, :end_to_end, :routes_test, :smoke_test],
    do: ["lib", "test/support"]

  defp elixirc_paths(mix_env) when mix_env == :dev,
    do: ["lib", "benchmark", "test/support/fixtures", "test/support/transformer_examples"]

  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      test: ["test --no-start"],
      test_e2e: ["cmd MIX_ENV=end_to_end mix test --color"],
      routes_test: ["cmd MIX_ENV=routes_test mix test --color"],
      # for smoke_test, see lib/mix/tasks/smoke_test.ex
      t: ["format", "cmd mix test --force --color"]
    ]
  end

  defp test_pattern(mix_env) when mix_env == :end_to_end, do: "end_to_end/*_test.ex"
  defp test_pattern(mix_env) when mix_env == :routes_test, do: "routes/*_test.ex"
  defp test_pattern(mix_env) when mix_env == :smoke_test, do: "smoke/**/*.ex"
  defp test_pattern(_mix_env), do: "*_test.exs"

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
      {:credo, "~> 1.4.0", only: [:dev, :test], runtime: false},
      {:crimpex, git: "https://github.com/bbc-news/Crimpex.git"},
      {:distillery, "~> 2.0"},
      {:eljiffy, "~> 1.3.0"},
      {:ex_aws,
       git: "https://github.com/ex-aws/ex_aws", ref: "9dbb11ce5b9c0c2974b7c86ac32f1dbc983b08a2", override: true},
      {:ex_aws_lambda, git: "https://github.com/james-bowers/ex_aws_lambda.git", branch: "x_ray_trace_id"},
      {:ex_aws_sts, git: "https://github.com/ex-aws/ex_aws_sts.git"},
      {:ex_metrics, git: "https://github.com/bbc/ExMetrics.git"},
      {:aws_ex_ray, "~> 0.1.15"},
      {:logger_file_backend, "~> 0.0.10"},
      {:mock, "~> 0.3", only: :test},
      {:machine_gun, "~> 0.1.6"},
      {:poolboy, "~> 1.5.1"},
      {:mox, "~> 0.5", only: [:test, :end_to_end, :routes_test, :smoke_test]},
      {:plug_cowboy, "~> 2.0"},
      {:stump, "~> 1.6"},
      {:sweet_xml, "~> 0.6"},
      {:cachex, "~> 3.1"},
      {:ets_cleaner, git: "https://github.com/bbc/ets_cleaner.git"},
      {:poison, "~> 3.1"},
      {:secure_random, "~> 0.5.1"},
      {:tabula, "~> 2.1.1", only: [:dev]},
      {:x509, "~> 0.8", only: :dev},
      {:telemetry, "~> 0.4.2"},
      {:telemetry_poller, "~> 0.4"},
      {:telemetry_metrics, "~> 0.5"},
      {:telemetry_metrics_statsd, "~> 0.4"}
    ]
  end
end
