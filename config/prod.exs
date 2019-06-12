use Mix.Config

config :ingress,
  lambda_presentation_role: System.get_env("LAMBDA_PRESENTATION_ROLE"),
  lambda_presentation_layer: System.get_env("LAMBDA_PRESENTATION_LAYER"),
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
