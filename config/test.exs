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
  machine_gun: Belfrage.Clients.HTTP.MachineGunMock,
  aws: Belfrage.AWSMock,
  xray: Belfrage.XrayMock,
  ccp_client: Belfrage.Clients.CCPMock,
  ccp_s3_bucket: "belfrage-distributed-cache-test",
  dial: Belfrage.Dials.ServerMock,
  expiry_validator: Belfrage.Authentication.Validator.ExpiryMock,
  event: Belfrage.EventMock,
  jwk_polling_enabled: false,
  webcore_credentials_source: Belfrage.Services.Webcore.Credentials.Env,
  webcore_credentials_polling_enabled: false,
  webcore_credentials_session_token: "stub-access-key-id",
  webcore_credentials_access_key_id: "stub-secret-access-key",
  webcore_credentials_secret_access_key: "stub-session-token",
  fabl_endpoint: "https://fabl.example.com",
  morph_router_endpoint: "https://morph-router.example.com",
  mozart_news_endpoint: "https://mozart-news.example.com",
  mozart_sport_endpoint: "https://mozart-sport.example.com",
  mozart_weather_endpoint: "https://mozart-weather.example.com",
  simorgh_endpoint: "https://simorgh.example.com",
  programmes_endpoint: "https://programmes.example.com",

  # Arbitrary long values so that the corresponding operations are never
  # executed in tests
  short_counter_reset_interval: 3_600_000,
  long_counter_reset_interval: 3_600_000,
  dials_startup_polling_delay: 3_600_000,
  bbc_id_availability_poll_interval: 3_600_000

config :cachex, :limit,
  size: 6,
  policy: Cachex.Policy.LRW,
  reclaim: 0.5,
  options: []

config :logger, :console,
  format: {Belfrage.Logger.Formatter, :format},
  colors: [enabled: false],
  metadata: :all
