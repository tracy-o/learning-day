use Mix.Config

config :ingress, instance_role_name:        System.get_env("INSTANCE_ROLE_NAME")
config :ingress, lambda_presentation_role:  System.get_env("LAMBDA_PRESENTATION_ROLE")
config :ingress, lambda_business_role:      System.get_env("LAMBDA_BUSINESS_ROLE")
config :ingress, lambda_presentation_layer: System.get_env("LAMBDA_PRESENTATION_LAYER")
config :ingress, lambda_business_layer:     System.get_env("LAMBDA_BUSINESS_LAYER")
