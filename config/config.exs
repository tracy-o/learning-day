# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

default_machine_gun_config = %{
  # Poolboy size
  pool_size: 512,
  # Poolboy max_overflow
  pool_max_overflow: 4096,
  pool_queue: false,
  pool_timeout: 300_000,
  # Gun connection options
  conn_opts: %{}
}

secure_machine_gun_config = %{
  default_machine_gun_config
  | conn_opts: %{
      transport_opts: [
        {:cacertfile, System.get_env("CLIENT_CERT_CA")},
        {:certfile, System.get_env("CLIENT_CERT")},
        {:keyfile, System.get_env("CLIENT_CERT_KEY")}
      ]
    }
}

config :machine_gun,
  default: default_machine_gun_config,
  AccountAuthentication: default_machine_gun_config,
  AWS: default_machine_gun_config,
  Fabl: secure_machine_gun_config,
  MorphRouter: secure_machine_gun_config,
  MozartNews: default_machine_gun_config,
  MozartSport: default_machine_gun_config,
  MozartWeather: default_machine_gun_config,
  OriginSimulator: default_machine_gun_config,
  Programmes: default_machine_gun_config,
  S3: default_machine_gun_config,
  Simorgh: default_machine_gun_config,
  Webcore: default_machine_gun_config

config :ex_aws,
  region: "eu-west-1",
  http_client: Belfrage.AWS.HttpClient,
  json_codec: Eljiffy

config :ex_aws, :retries,
  max_attempts: 1,
  base_backoff_in_ms: 10,
  max_backoff_in_ms: 200

config :belfrage,
  short_counter_reset_interval: 5_000,
  long_counter_reset_interval: 60_000,
  fetch_loop_timeout: 250,
  dials_location: "/etc/cosmos-dials/dials.json",
  dials_startup_polling_delay: 0,
  errors_threshold: 100,
  json_codec: Eljiffy,
  origin_simulator: System.get_env("ORIGIN_SIMULATOR"),
  lambda_timeout: 3_600,
  default_timeout: 6_000,
  s3_http_client_timeout: 1_000,
  machine_gun: Belfrage.Clients.HTTP.MachineGun,
  webcore_credentials_source: Belfrage.Services.Webcore.Credentials.STS,
  webcore_credentials_polling_enabled: true,
  aws: Belfrage.AWS,
  ccp_client: Belfrage.Clients.CCP,
  dial: Belfrage.Dials.LiveServer,
  authentication_client: Belfrage.Clients.Authentication,
  expiry_validator: Belfrage.Authentication.Validator.Expiry,
  xray: Belfrage.Xray,
  monitor_api: Belfrage.Monitor,
  event: Belfrage.Event,
  stack_name: "belfrage-stack",
  stack_id: "local",
  redirect_statuses: [301, 302, 307, 308],
  dial_handlers: %{
    "circuit_breaker" => Belfrage.Dials.CircuitBreaker,
    "webcore_ttl_multiplier" => Belfrage.Dials.WebcoreTtlMultiplier,
    "non_webcore_ttl_multiplier" => Belfrage.Dials.NonWebcoreTtlMultiplier,
    "logging_level" => Belfrage.Dials.LoggingLevel,
    "personalisation" => Belfrage.Dials.Personalisation,
    "obit_mode" => Belfrage.Dials.ObitMode,
    "ccp_enabled" => Belfrage.Dials.CcpEnabled,
    "monitor_enabled" => Belfrage.Dials.MonitorEnabled,
    "webcore_kill_switch" => Belfrage.Dials.WebcoreKillSwitch,
    "datalab_machine_recommendations" => Belfrage.Dials.DatalabMachineRecommendations,
    "chameleon" => Belfrage.Dials.Chameleon
  },
  pool_metric_rate: 10_000,
  authentication: %{
    "iss" => "https://access.int.api.bbc.com/bbcidv5/oauth2",
    "aud" => "Account",
    "account_jwk_uri" => "https://access.int.api.bbc.com/v1/oauth/connect/jwk_uri",
    "session_url" => "https://session.test.bbc.co.uk",
    "idcta_config_uri" => "https://idcta.test.api.bbc.co.uk/idcta/config",
    "jwt_expiry_window" => 4200
  },
  bbc_id_availability_poll_interval: 10_000,
  jwk_polling_enabled: true,
  not_found_page: "priv/static/default_error_pages/not_found.html",
  not_supported_page: "priv/static/default_error_pages/not_supported.html",
  internal_error_page: "priv/static/default_error_pages/internal_error.html"

config :cachex, :limit,
  size: 36_000,
  # [RESFRAME-3994] Actually LRU, see lib/belfrage/cache/local.ex
  policy: Cachex.Policy.LRW,
  reclaim: 0.3,
  options: []

config :logger,
  backends: [{LoggerFileBackend, :file}, {LoggerFileBackend, :cloudwatch}]

config :logger, :file,
  path: "local.log",
  format: {Belfrage.Logger.Formatter, :app},
  level: :debug,
  metadata: :all

config :logger, :cloudwatch,
  path: "cloudwatch.log",
  format: {Belfrage.Logger.Formatter, :cloudwatch},
  level: :warn,
  metadata: :all,
  metadata_filter: [cloudwatch: true]

config :aws_ex_ray,
  store_monitor_pool_size: 512,
  client_pool_size: 512

import_config "#{Mix.env()}.exs"
