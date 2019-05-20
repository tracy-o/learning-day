# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :ingress, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:ingress, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#

config :ingress,
  circuit_breaker_reset_interval: 60_000,
  fallback: System.get_env("INGRESS_FALLBACK"),
  origin: System.get_env("INGRESS_ORIGIN"),
  errors_threshold: 1_000,
  service_provider: Ingress.ServiceProvider

config :logger, :console, format: "$message\n"

config :ex_aws,
  region: "eu-west-1",
  http_client: Mojito

import_config "#{Mix.env()}.exs"
import_config "metrics.exs"
