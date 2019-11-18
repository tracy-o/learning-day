use Mix.Config

config :belfrage,
  origin_simulator: "http://test-compo-1chgcj5evn9oo-f0a64863a5d33db4.elb.eu-west-1.amazonaws.com",
  pwa_lambda_function: "pwa-lambda-function",
  api_lambda_function: "api-lambda-function",
  playground_api_lambda_function: "playground-api-lambda-function",
  playground_pwa_lambda_function: "playground-pwa-lambda-function",
  preview_pwa_lambda_function: "preview-pwa-lambda-function",
  preview_api_lambda_function: "preview-api-lambda-function",
  webcore_lambda_role_arn: "webcore-lambda-role-arn",
  playground_lambda_role_arn: "playground-lambda-role-arn",
  production_environment: "test"

config :ex_metrics,
  send_metrics: false
