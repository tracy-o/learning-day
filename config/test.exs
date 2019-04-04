use Mix.Config

config :ingress,
  http_port: 7081,
  instance_role_name: "ec2-role",
  lambda_presentation_role: "presentation-role",
  lambda_business_role: "business-role",
  lambda_presentation_layer: "presentation-layer",
  lambda_business_layer: "business-layer",
  lambda_service_worker: "service-worker",
  lambda_service_worker_role: "service-worker-role",
  http_scheme: :http,
  errors_threshold: 20,
  # 1 sec window before resetting the circuit breaker
  errors_interval: 1_000,
  origin: "https://origin.bbc.com/",
  fallback: "https://s3.aws.com/",
  ingress: IngressMock,
  service: Ingress.Services.ServiceMock
