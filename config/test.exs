use Mix.Config

config :belfrage,
  aws_client: ExAwsMock,
  circuit_breaker_reset_interval: 100,
  errors_threshold: 20,
  http_client: Belfrage.Clients.HTTPMock,
  lambda_client: Belfrage.Clients.LambdaMock,
  belfrage: BelfrageMock,
  webcore_lambda_role_arn: "webcore-lambda-role-arn",
  pwa_lambda_function: "pwa-lambda-function",
  api_lambda_function: "api-lambda-function",
  service_worker_lambda_function: "service-worker-lambda-function",
  preview_pwa_lambda_function: "preview-pwa-lambda-function",
  preview_api_lambda_function: "preview-api-lambda-function",
  preview_service_worker_lambda_function: "preview-service-worker-lambda-function",
  production_environment: "test",
  lambda_timeout: 1_000,
  origin_simulator: "http://origin.bbc.com"

config :ex_metrics,
  send_metrics: false

config :logger,
  backends: []
