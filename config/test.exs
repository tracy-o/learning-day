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
  event: Belfrage.EventMock,
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
  ]

config :cachex, :limit,
  size: 6,
  policy: Cachex.Policy.LRW,
  reclaim: 0.5,
  options: []

config :logger, :console,
  format: {Belfrage.Logger.Formatter, :format},
  colors: [enabled: false],
  metadata: :all
