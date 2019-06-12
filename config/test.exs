use Mix.Config

config :ingress,
  circuit_breaker_reset_interval: 1_000,
  errors_threshold: 20,
  fallback: "https://s3.aws.com/",
  http_client: Ingress.Clients.HTTPMock,
  lambda_client: Ingress.Clients.LambdaMock,
  ingress: IngressMock,
  instance_role_name: "ec2-role",
  lambda_presentation_layer: "presentation-layer",
  lambda_presentation_role: "presentation-role",
  origin: "https://origin.bbc.com/"

config :ex_metrics,
  send_metrics: false

config :logger,
  backends: []
