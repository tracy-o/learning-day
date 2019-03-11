use Mix.Config

config :ingress, http_port: 7081
config :ingress, instance_role_name: "ec2-role"
config :ingress, lambda_presentation_role: "presentation-role"
config :ingress, lambda_business_role: "business-role"
config :ingress, lambda_presentation_layer: "presentation-layer"
config :ingress, lambda_business_layer: "business-layer"
config :ingress, lambda_service_worker: "service-worker"
config :ingress, lambda_service_worker_role: "service-worker-role"
config :ingress, http_scheme: :http
config :ingress, errors_threshold: 20
config :ingress, errors_interval: 1_000 # 1 sec window before resetting the circuit breaker
config :ingress, origin: "https://origin.bbc.com/"
config :ingress, fallback: "https://s3.aws.com/"
