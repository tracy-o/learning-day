use Mix.Config

config :belfrage,
  origin: "http://test-compo-1chgcj5evn9oo-f0a64863a5d33db4.elb.eu-west-1.amazonaws.com",
  webcore_lambda_name_progressive_web_app: "webcore-lambda-name-progressive-web-app",
  webcore_lambda_role_arn: "webcore-lambda-role-arn"

config :ex_metrics,
  send_metrics: false
