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
  },
  fabl: %{
    # Poolboy size
    pool_size: 512,
    # Poolboy max_overflow
    pool_max_overflow: 256,
    pool_timeout: 6_000,
    # Gun connection options
    conn_opts: %{
      transport_opts: [
        {:cacertfile, System.get_env("CA_FILE_PATH")},
        {:certfile, System.get_env("CERT_FILE_PATH")},
        {:keyfile, System.get_env("KEY_FILE_PATH")}
      ]
    }
  }

config :ex_aws, :retries,
  max_attempts: 2,
  base_backoff_in_ms: 10,
  max_backoff_in_ms: 200

config :belfrage,
  short_counter_reset_interval: 5_000,
  long_counter_reset_interval: 60_000,
  dials_location: "/etc/cosmos-dials/dials.json",
  errors_threshold: 100,
  json_codec: Eljiffy,
  origin_simulator: System.get_env("ORIGIN_SIMULATOR"),
  lambda_timeout: 5_000,
  default_timeout: 6_000,
  machine_gun: Belfrage.Clients.HTTP.MachineGun,
  credential_strategy: Belfrage.Credentials.STS,
  aws: Belfrage.AWS,
  aws_sts: Belfrage.AWS.STS,
  aws_lambda: Belfrage.AWS.Lambda,
  file_io: Belfrage.Helpers.FileIO,
  routefile: Routes.Routefile,
  xray: Belfrage.Xray

config :ex_aws,
  region: "eu-west-1",
  http_client: Belfrage.Clients.Lambda,
  json_codec: Eljiffy

import_config "#{Mix.env()}.exs"
import_config "metrics.exs"
