use Mix.Config

config :belfrage,
  http_cert: System.get_env("HTTP_CERT"),
  http_cert_key: System.get_env("HTTP_CERT_KEY"),
  http_cert_ca: System.get_env("HTTP_CERT_CA"),
  not_found_page: "priv/static/not-found.html",
  internal_error_page: "priv/static/internal-error.html"

config :ex_metrics,
  send_metrics: true

config :logger,
  backends: [{LoggerFileBackend, :file}]

config :logger, :file,
  path: System.get_env("LOG_PATH"),
  format: "$message\n",
  level: :error
