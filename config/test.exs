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
config :ingress, guardian_threshold: 20  # per min
config :ingress, guardian_interval:  5   # 5sec

config :ingress, fallback: "https://s3.aws.com/"
