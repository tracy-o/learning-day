use Mix.Config

config :ingress,
  lambda_presentation_role: System.get_env("LAMBDA_PRESENTATION_ROLE"),
  lambda_business_role: System.get_env("LAMBDA_BUSINESS_ROLE"),
  lambda_presentation_layer: System.get_env("LAMBDA_PRESENTATION_LAYER"),
  lambda_business_layer: System.get_env("LAMBDA_BUSINESS_LAYER"),
  lambda_service_worker: System.get_env("LAMBDA_SERVICE_WORKER"),
  lambda_service_worker_role: System.get_env("LAMBDA_SERVICE_WORKER_ROLE"),
  http_cert: System.get_env("HTTP_CERT"),
  http_cert_key: System.get_env("HTTP_CERT_KEY"),
  http_cert_ca: System.get_env("HTTP_CERT_CA")

config :ex_metrics,
  send_metrics: true

config :logger,
  backends: [{LoggerFileBackend, :file}, :console]

config :logger, :file,
  path: System.get_env("LOG_PATH"),
  format: "$message\n",
  level: :error
