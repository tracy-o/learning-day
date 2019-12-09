use Mix.Config

config :belfrage,
  origin_simulator: "http://test-compo-1chgcj5evn9oo-f0a64863a5d33db4.elb.eu-west-1.amazonaws.com",
  pwa_lambda_function: "pwa-lambda-function",
  api_lambda_function: "api-lambda-function",
  preview_pwa_lambda_function: "preview-pwa-lambda-function",
  preview_api_lambda_function: "preview-api-lambda-function",
  webcore_lambda_role_arn: "webcore-lambda-role-arn",
  production_environment: "test",
  credential_strategy: Belfrage.Credentials.LocalDev

config :ex_metrics,
  send_metrics: false
