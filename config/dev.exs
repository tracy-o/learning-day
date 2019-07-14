use Mix.Config

config :belfrage,
  origin: "http://test-compo-1chgcj5evn9oo-f0a64863a5d33db4.elb.eu-west-1.amazonaws.com",
  pwa_lambda_function: "pwa-lambda-function",
  webcore_lambda_role_arn: "pwa-lambda-role-arn"

config :ex_metrics,
  send_metrics: false
