use Mix.Config

config :ingress,
  circuit_breaker_reset_interval: 1_000,
  errors_threshold: 20,
  fallback: "https://s3.aws.com/",
  http_client: Ingress.HTTPClientMock,
  ingress: IngressMock,
  instance_role_name: "ec2-role",
  lambda_business_layer: "business-layer",
  lambda_business_role: "business-role",
  lambda_presentation_layer: "presentation-layer",
  lambda_presentation_role: "presentation-role",
  lambda_service_worker: "service-worker",
  lambda_service_worker_role: "service-worker-role",
  origin: "https://origin.bbc.com/",
  service_provider: Ingress.ServiceProviderMock

config :ex_aws,
  region: "eu-west-1",
  http_client: Ingress.LambdaClientMock

config :ex_metrics,
  send_metrics: false

config :logger,
  backends: []
