use Mix.Config

config :ingress, lambda_presentation_role: System.get_env("LAMBDA_PRESENTATION_ROLE")
config :ingress, lambda_business_role: System.get_env("LAMBDA_BUSINESS_ROLE")
config :ingress, lambda_presentation_layer: System.get_env("LAMBDA_PRESENTATION_LAYER")
config :ingress, lambda_business_layer: System.get_env("LAMBDA_BUSINESS_LAYER")
config :ingress, lambda_service_worker: System.get_env("LAMBDA_SERVICE_WORKER")
config :ingress, lambda_service_worker_role: System.get_env("LAMBDA_SERVICE_WORKER_ROLE")
config :ingress, http_cert: System.get_env("HTTP_CERT")
config :ingress, http_cert_key: System.get_env("HTTP_CERT_KEY")
config :ingress, http_cert_ca: System.get_env("HTTP_CERT_CA")

config :ex_metrics,
  send_metrics: true


config :logger,
       backends: [{LoggerFileBackend, :file}, :console]

config :logger, :file,
       path: "/var/log/mozart_fetcher/error.log",
       format: "$message\n",
       level: :error