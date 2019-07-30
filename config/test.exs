use Mix.Config

config :belfrage,
  aws_client: ExAwsMock,
  circuit_breaker_reset_interval: 1_000,
  errors_threshold: 20,
  fallback: "https://s3.aws.com/",
  http_client: Belfrage.Clients.HTTPMock,
  lambda_client: Belfrage.Clients.LambdaMock,
  belfrage: BelfrageMock,
  origin: "https://origin.bbc.com/",
  webcore_lambda_role_arn: "webcore-lambda-role-arn",
  pwa_lambda_function: "pwa-lambda-function",
  graphql_lambda_function: "graphql-lambda-function",
  service_worker_lambda_function: "service-worker-lambda-function",
  production_environment: "test",
  lambda_timeout: 10_000

config :ex_metrics,
  send_metrics: false

config :logger,
  backends: []
