# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :machine_gun,
  default: %{
    # Poolboy size
    pool_size: 512,
    # Poolboy max_overflow
    pool_max_overflow: 256,
    pool_timeout: 6_000,
    # Gun connection options
    conn_opts: %{}
  }

config :ex_aws, :retries,
  max_attempts: 2,
  base_backoff_in_ms: 10,
  max_backoff_in_ms: 200

config :belfrage,
  aws_client: ExAws,
  circuit_breaker_reset_interval: 5_000,
  errors_threshold: 100,
  origin_simulator: System.get_env("ORIGIN_SIMULATOR"),
  lambda_timeout: 5_000,
  default_timeout: 6_000

config :ex_aws,
  region: "eu-west-1",
  http_client: Belfrage.Clients.Lambda,
  json_codec: Eljiffy

import_config "#{Mix.env()}.exs"
import_config "metrics.exs"
