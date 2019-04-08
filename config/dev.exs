use Mix.Config

config :ingress,
  instance_role_name: "ec2-role",
  lambda_presentation_role: "presentation-role",
  lambda_business_role: "business-role",
  lambda_presentation_layer: "presentation-layer",
  lambda_business_layer: "business-layer",
  lambda_service_worker: "service-worker",
  lambda_service_worker_role: "service-worker-arn",
  http_port: 7080,
  http_scheme: :http,
  origin: "http://test-compo-1chgcj5evn9oo-f0a64863a5d33db4.elb.eu-west-1.amazonaws.com"
