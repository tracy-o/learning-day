use Mix.Config

config :ingress,
  circuit_breaker_reset_interval: 1_000,
  errors_threshold: 20,
  fallback: "https://s3.aws.com/",
  http_client: Ingress.Clients.HTTPMock,
  lambda_client: Ingress.Clients.LambdaMock,
  ingress: IngressMock,
  instance_role_name: "ec2-role",
  origin: "https://origin.bbc.com/",
  webcore_lambda_name_progressive_web_app: "webcore-lambda-name-progressive-web-app",
  webcore_lambda_role_arn: "webcore-lambda-role-arn"

config :ex_metrics,
  send_metrics: false

config :logger,
  backends: []
