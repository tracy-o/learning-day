use Mix.Config

config :belfrage,
  origin: "http://test-compo-1chgcj5evn9oo-f0a64863a5d33db4.elb.eu-west-1.amazonaws.com",
  pwa_lambda_function: "pwa-lambda-function",
  graphql_lambda_function: "graphql-lambda-function",
  service_worker_lambda_function: "service-worker-lambda-function",
  preview_pwa_lambda_function: "preview-pwa-lambda-function",
  preview_graphql_lambda_function: "preview-graphql-lambda-function",
  preview_service_worker_lambda_function: "preview-service-worker-lambda-function",
  webcore_lambda_role_arn: "webcore-lambda-role-arn",
  production_environment: "test"

config :ex_metrics,
  send_metrics: false
