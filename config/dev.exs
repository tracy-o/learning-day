use Mix.Config

config :ingress, instance_role_name: "ec2-role"
config :ingress, lambda_presentation_role: "presentation-role"
config :ingress, lambda_business_role: "business-role"
config :ingress, lambda_presentation_layer: "presentation-layer"
config :ingress, lambda_business_layer: "business-layer"
config :ingress, lambda_service_worker: "service-worker"
config :ingress, lambda_service_worker_role: "service-worker-arn"
config :ingress, http_port: 7080
config :ingress, http_scheme: :http
