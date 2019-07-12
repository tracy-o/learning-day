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
  pwa_lambda_function: "webcore-lambda-name-progressive-web-app",
  pwa_lambda_role_arn: "webcore-lambda-role-arn",
  graphql_lambda_function: "graphql-lambda-function",
  graphql_lambda_role_arn: "graphql-lambda-role-arn",
  service_worker_lambda_function: "service-worker-lambda-function",
  service_worker_lambda_role_arn: "service-worker-lambda-role-arn"

config :ex_metrics,
  send_metrics: false

config :logger,
  backends: []
