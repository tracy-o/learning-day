# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :ex_aws, :retries,
  max_attempts: 1,
  base_backoff_in_ms: 10,
  max_backoff_in_ms: 200

config :belfrage,
  aws_client: ExAws,
  circuit_breaker_reset_interval: 60_000,
  errors_threshold: 1_000,
  fallback: System.get_env("BELFRAGE_FALLBACK"),
  origin_simulator: System.get_env("ORIGIN_SIMULATOR"),
  lambda_timeout: 10_000

config :logger, :console, format: "$message\n"

config :ex_aws,
  region: "eu-west-1",
  http_client: Belfrage.Clients.Lambda,
  json_codec: Eljiffy

import_config "#{Mix.env()}.exs"
import_config "metrics.exs"
