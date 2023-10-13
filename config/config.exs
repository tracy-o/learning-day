# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
import Config

config :finch,
  pool_timeout: 1_000,
  cacertfile: System.get_env("CLIENT_CERT_CA"),
  certfile: System.get_env("CLIENT_CERT"),
  keyfile: System.get_env("CLIENT_CERT_KEY")

config :ex_aws,
  region: "eu-west-1",
  http_client: Belfrage.AWS.HttpClient,
  json_codec: Json

config :ex_aws, :retries,
  max_attempts: 1,
  base_backoff_in_ms: 10,
  max_backoff_in_ms: 200

config :belfrage,
  route_state_reset_interval: 60_000,
  mvt_vary_header_ttl: 3_600_000,
  fetch_route_state_timeout: 250,
  dials_location: "/etc/cosmos-dials/dials.json",
  errors_threshold: 100,
  json_codec: Json,
  origin_simulator: System.get_env("ORIGIN_SIMULATOR"),
  lambda_timeout: 3_600,
  default_timeout: 6_000,
  s3_http_client_timeout: 400,
  webcore_credentials_source: Belfrage.Services.Webcore.Credentials.STS,
  aws: Belfrage.AWS,
  ccp_client: Belfrage.Clients.CCP,
  dial: Belfrage.Dials.State,
  authentication_client: Belfrage.Clients.Authentication,
  json_client: Belfrage.Clients.Json,
  expiry_validator: Belfrage.Authentication.Validator.Expiry,
  xray: Belfrage.Xray,
  stack_name: "belfrage-stack",
  stack_id: "local",
  redirect_statuses: [301, 302, 307, 308],
  pool_metric_rate: 10_000,
  authentication: %{
    "account_jwk_uri" => "https://access.int.api.bbc.com/v1/oauth/connect/jwk_uri",
    "session_url" => "https://session.test.bbc.co.uk",
    "idcta_config_uri" => "https://idcta.test.api.bbc.co.uk/idcta/config",
    "jwt_expiry_window" => 4200
  },
  not_found_page: "priv/static/default_error_pages/not_found.html",
  not_supported_page: "priv/static/default_error_pages/not_supported.html",
  internal_error_page: "priv/static/default_error_pages/internal_error.html",
  mvt: %{
    slots_file_location: "https://test-mvt-slot-allocations.s3.eu-west-1.amazonaws.com/development.json"
  },
  poller_intervals: [
    jwk: 3_600_000,
    dials: 5_000,
    credentials: 600_000,
    bbc_id_availability: 10_000,
    mvt_file: 60_000
  ],
  date_time: Belfrage.Utils.Current.Real,
  preflight_metadata_cache: [
    # 20 hours - temporary for testing purposes
    default_ttl_ms: 72_000_000,
    expiration_interval_ms: 60_000,
    limit: [
      size: 48_000,
      # [RESFRAME-3994] Actually LRU, see lib/belfrage/cache/local.ex
      policy: Cachex.Policy.LRW,
      reclaim: 0.3,
      options: []
    ]
  ],
  cache: [
    limit: [
      average_entry_size_kb: 170,
      ram_allocated: 0.4,
      # [RESFRAME-3994] Actually LRU, see lib/belfrage/cache/local.ex
      policy: Cachex.Policy.LRW,
      reclaim: 0.3,
      options: []
    ]
  ]

config :logger,
  backends: [{LoggerFileBackend, :file}, {LoggerFileBackend, :access}]

config :logger, :file,
  path: "local.log",
  format: {Belfrage.Logger.Formatter, :app},
  level: :debug,
  metadata: :all

config :logger, :access,
  path: "access.log",
  format: {Belfrage.Logger.Formatter, :access},
  level: :info,
  metadata: :all,
  metadata_filter: [access: true]

config :aws_ex_ray,
  store_monitor_pool_size: 1,
  client_pool_size: 512

config :plug_cowboy,
  conn_in_exception_metadata: false

config :os_mon,
  start_cpu_sup: false,
  start_disksup: false,
  start_memsup: true,
  start_os_sup: false

import_config "dials.exs"
import_config "#{Mix.env()}.exs"
