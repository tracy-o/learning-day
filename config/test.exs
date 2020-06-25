use Mix.Config

config :belfrage,
  short_counter_reset_interval: 100,
  long_counter_reset_interval: 100,
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
  aws_sts: Belfrage.AWS.STSMock,
  aws_lambda: Belfrage.AWS.LambdaMock,
  file_io: Belfrage.Helpers.FileIOMock,
  routefile: Routes.RoutefileMock,
  xray: Belfrage.XrayMock,
  ccp_client: Belfrage.Clients.CCPMock,
  ccp_s3_bucket: "belfrage-distributed-cache-test",
  not_found_page: "test/support/resources/not-found.html",
  not_supported_page: "test/support/resources/not-supported.html",
  internal_error_page: "test/support/resources/internal-error.html"

config :cachex, :limit,
  size: 6,
  policy: Cachex.Policy.LRW,
  reclaim: 0.5,
  options: []

config :ex_metrics,
  send_metrics: false
