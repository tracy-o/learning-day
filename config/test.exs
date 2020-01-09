use Mix.Config

config :belfrage,
  aws_client: ExAwsMock,
  short_counter_reset_interval: 100,
  long_counter_reset_interval: 100,
  dials_location: "test/support/resources/dials.json",
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
  aws_sts: Belfrage.AWS.STSMock,
  worker_process_init_pause_time: 1_000

config :ex_metrics,
  send_metrics: false

config :logger,
  backends: []
