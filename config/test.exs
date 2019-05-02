use Mix.Config

config :ingress,
  instance_role_name: "ec2-role",
  lambda_presentation_role: "presentation-role",
  lambda_business_role: "business-role",
  lambda_presentation_layer: "presentation-layer",
  lambda_business_layer: "business-layer",
  lambda_service_worker: "service-worker",
  lambda_service_worker_role: "service-worker-role",
  errors_threshold: 20,
  # 1 sec window before resetting the circuit breaker
  errors_interval: 1_000,
  origin: "https://origin.bbc.com/",
  fallback: "https://s3.aws.com/",
  ingress: IngressMock,
  http_service: Ingress.Services.HTTPMock,
  lambda_service: Ingress.Services.LambdaMock,
  http_client: Ingress.Services.HTTPClientMock

config :ex_metrics,
  send_metrics: false

config :logger,
  backends: []
