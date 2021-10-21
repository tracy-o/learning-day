use Mix.Config

config :belfrage,
  errors_threshold: 20,
  http_client: Belfrage.Clients.HTTPMock,
  lambda_client: Belfrage.Clients.LambdaMock,
  belfrage: BelfrageMock,
  webcore_lambda_role_arn: "webcore-lambda-role-arn",
  pwa_lambda_function: "pwa-lambda-function",
  production_environment: "test",
  preview_mode: "off",
  lambda_timeout: 1_000,
  origin_simulator: "http://origin.bbc.com",
  machine_gun: Belfrage.Clients.HTTP.MachineGunMock,
  aws: Belfrage.AWSMock,
  file_io: Belfrage.Helpers.FileIOMock,
  xray: Belfrage.XrayMock,
  ccp_client: Belfrage.Clients.CCPMock,
  ccp_s3_bucket: "belfrage-distributed-cache-test",
  dial: Belfrage.Dials.ServerMock,
  dials_location: "test/support/resources/dials.json",
  authentication_client: Belfrage.Clients.AuthenticationMock,
  expiry_validator: Belfrage.Authentication.Validator.ExpiryMock,
  event: Belfrage.EventMock,
  not_found_page: "test/support/resources/not-found.html",
  not_supported_page: "test/support/resources/not-supported.html",
  internal_error_page: "test/support/resources/internal-error.html",
  mailbox_monitors: [],
  monitor_api: Belfrage.MonitorStub,

  # Arbitrary long values so that the corresponding operations are never
  # executed in tests
  short_counter_reset_interval: 3_600_000,
  long_counter_reset_interval: 3_600_000,
  bbc_id_availability_poll_interval: 3_600_000

config :cachex, :limit,
  size: 6,
  policy: Cachex.Policy.LRW,
  reclaim: 0.5,
  options: []
