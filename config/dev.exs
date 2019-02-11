use Mix.Config

config :ingress, ec2_role: "ec2-role"
config :ingress, lambda_presentation_role: "presentation-role"
config :ingress, lambda_business_role: "business-role"
config :ingress, lambda_presentation_layer: "presentation-layer"
config :ingress, lambda_business_layer: "business-layer"
