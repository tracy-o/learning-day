# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :mojito,
  pool_opts: [
    size: 20,
    pools: 10,
    max_overflow: 20
  ]

config :ex_aws, :retries,
  max_attempts: 2,
  base_backoff_in_ms: 10,
  max_backoff_in_ms: 200

config :belfrage,
  aws_client: ExAws,
  circuit_breaker_reset_interval: 5_000,
  errors_threshold: 100,
  origin_simulator: System.get_env("ORIGIN_SIMULATOR"),
  lambda_timeout: 5_000

config :ex_aws,
  region: "eu-west-1",
  http_client: Belfrage.Clients.Lambda,
  json_codec: Eljiffy

import_config "#{Mix.env()}.exs"
import_config "metrics.exs"
