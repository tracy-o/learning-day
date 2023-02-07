defmodule Belfrage.MixProject do
  use Mix.Project

  @test_envs ~w(test smoke_test)a

  def project do
    [
      app: :belfrage,
      version: "0.2.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env()),
      aliases: aliases(),
      test_pattern: test_pattern(Mix.env()),
      warn_test_pattern: test_pattern(Mix.env()),
      xref: [exclude: [:memsup]]
    ]
  end

  defp elixirc_paths(mix_env) when mix_env in @test_envs,
    do: ["lib", "test/support"]

  defp elixirc_paths(mix_env) when mix_env == :dev,
    do: [
      "lib",
      "benchmark",
      "test/support/fixtures",
      "test/support/mocks"
    ]

  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      # for smoke_test, see lib/mix/tasks/smoke_test.ex
      t: ["format", "cmd mix test --force --color"],
      test: ["test --color --trace"]
    ]
  end

  defp test_pattern(mix_env) when mix_env == :smoke_test, do: "smoke/**/*.ex"
  defp test_pattern(_mix_env), do: "*_test.exs"

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:aws_ex_ray, :logger, :cachex],
      mod: {Belfrage.Application, [env: Mix.env()]}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:uuid, "~> 1.1"},
      {:benchee, "~> 1.1", only: :dev},
      {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      {:crimpex, git: "https://github.com/bbc-news/Crimpex.git"},
      {:distillery, "~> 2.0"},
      {:jason, "~> 1.0"},
      {:jiffy, "~> 1.1"},
      {:ex_aws, "~> 2.0", [env: :prod, repo: "hexpm", hex: "ex_aws"]},
      {:ex_aws_lambda, "~> 2.1"},
      {:ex_aws_sts, git: "https://github.com/ex-aws/ex_aws_sts.git"},
      {:aws_ex_ray, "~> 0.1.15"},
      {:logger_file_backend, "~> 0.0.10"},
      {:finch, "~> 0.13.0"},
      {:mox, "~> 1.0.2", only: @test_envs},
      {:plug_cowboy, "~> 2.6"},
      {:sweet_xml, "~> 0.7"},
      {:cachex, "~> 3.4"},
      {:poison, "~> 5.0", override: true},
      {:secure_random, "~> 0.5.1"},
      {:tabula, "~> 2.2", only: [:dev] ++ @test_envs},
      {:x509, "~> 0.8", only: :dev},
      {:telemetry, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_metrics_statsd, "~> 0.6"},
      {:observer_cli, "~> 1.7", only: :dev},
      {:joken, "~> 2.5"},
      {:b64fast, "~> 0.2.3"},

      # Clustering
      {:libcluster, "~> 3.3"},
      {:libcluster_ec2, "~> 0.7"}
    ]
  end
end
