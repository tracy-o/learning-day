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
  preview_pwa_lambda_function: "preview-pwa-lambda-function",
  production_environment: "test",
  lambda_timeout: 1_000,
  origin_simulator: "http://origin.bbc.com",
  machine_gun: Belfrage.Clients.HTTP.MachineGunMock,
  aws: Belfrage.AWSMock,
  aws_sts: Belfrage.AWS.STSMock,
  aws_lambda: Belfrage.AWS.LambdaMock,
  file_io: Belfrage.Helpers.FileIOMock

config :ex_metrics,
  send_metrics: false

config :logger, backends: []
