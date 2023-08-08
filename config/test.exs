import Config

config :belfrage,
  errors_threshold: 20,
  http_client: Belfrage.Clients.HTTPMock,
  lambda_client: Belfrage.Clients.LambdaMock,
  webcore_lambda_role_arn: "webcore-lambda-role-arn",
  pwa_lambda_function: "pwa-lambda-function",
  production_environment: "test",
  preview_mode: "off",
  origin_simulator: "http://origin.bbc.com",
  aws: Belfrage.AWSMock,
  xray: Belfrage.XrayMock,
  ccp_client: Belfrage.Clients.CCPMock,
  finch_impl: FinchMock,
  ccp_s3_bucket: "belfrage-distributed-cache-test",
  dial: Belfrage.Dials.ServerMock,
  expiry_validator: Belfrage.Authentication.Validator.ExpiryMock,
  webcore_credentials_session_token: "stub-access-key-id",
  webcore_credentials_access_key_id: "stub-secret-access-key",
  webcore_credentials_secret_access_key: "stub-session-token",
  ares_endpoint: "https://ares-api.test.api.bbci.co.uk",
  fabl_endpoint: "https://fabl.example.com",
  morph_router_endpoint: "https://morph-router.example.com",
  mozart_news_endpoint: "https://mozart-news.example.com",
  mozart_sport_endpoint: "https://mozart-sport.example.com",
  mozart_weather_endpoint: "https://mozart-weather.example.com",
  simorgh_endpoint: "https://simorgh.example.com",
  programmes_endpoint: "https://programmes.example.com",
  karanga_endpoint: "https://broker.karanga.test.api.bbci.co.uk",
  philippa_endpoint: "https://philippa-producer.test.api.bbci.co.uk",
  trevor_endpoint: "https://trevor-producer.test.api.bbci.co.uk",
  walter_endpoint: "https://walter-producer.test.api.bbci.co.uk",
  dotcom_homepage_endpoint: "https://wwhp.gnl-test.bbcverticals.com",
  dotcom_culture_endpoint: "https://culture-features.gnl-test.bbcverticals.com",
  dotcom_future_endpoint: "https://future-features.gnl-test.bbcverticals.com",
  dotcom_reel_endpoint: "https://reel.gnl-test.bbcverticals.com",
  dotcom_travel_endpoint: "https://travel-features.gnl-test.bbcverticals.com",
  dotcom_worklife_endpoint: "https://worklife-features.gnl-test.bbcverticals.com",
  bbcx_endpoint: "https://web.test.bbcx-internal.com",
  electoral_commission_endpoint: "https://api.electoralcommission.org.uk",
  childrens_responsive_endpoint: "https://cbbc-web.test.api.bbc.co.uk",
  sup_observer_timer_ms: 10,
  # Arbitrary long values so that the corresponding operations are never
  # executed in tests
  short_counter_reset_interval: 3_600_000,
  long_counter_reset_interval: 3_600_000,
  poller_intervals: [
    jwk: 50,
    dials: 50,
    credentials: 50,
    bbc_id_availability: 50,
    mvt_file: 50
  ],
  date_time: Belfrage.Utils.Current.Mock,
  preflight_metadata_cache: [
    default_ttl_ms: 100,
    expiration_interval_ms: 60_000,
    limit: [
      size: 6,
      # [RESFRAME-3994] Actually LRU, see lib/belfrage/cache/local.ex
      policy: Cachex.Policy.LRW,
      reclaim: 0.5,
      options: []
    ]
  ]

config :cachex, :limit,
  size: 6,
  policy: Cachex.Policy.LRW,
  reclaim: 0.5,
  options: []

config :logger, :console,
  format: {Belfrage.Logger.Formatter, :app},
  colors: [enabled: false],
  metadata: :all

config :aws_ex_ray,
  store_monitor_pool_size: 1,
  client_pool_size: 1
