use Mix.Config

config :ingress, ec2_role:                  System.get_env("EC2_ROLE")
config :ingress, lambda_presentation_role:  System.get_env("LAMBDA_PRESENTATION_ROLE")
config :ingress, lambda_business_role:      System.get_env("LAMBDA_BUSINESS_ROLE")
config :ingress, lambda_presentation_layer: System.get_env("LAMBDA_PRESENTATION_LAYER")
config :ingress, lambda_business_layer:     System.get_env("LAMBDA_BUSINESS_LAYER")
