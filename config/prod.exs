use Mix.Config

config :belfrage,
  production_environment: "live",
  http_cert: System.get_env("HTTP_CERT"),
  http_cert_key: System.get_env("HTTP_CERT_KEY"),
  http_cert_ca: System.get_env("HTTP_CERT_CA"),
  not_found_page: "/var/www/html/errors/404-data-ssl.html",
  not_supported_page: "/var/www/html/errors/405-data-ssl.html",
  internal_error_page: "/var/www/html/errors/500-data-ssl.html"

config :statix,
  pool_size: 6

config :logger,
  backends: [{LoggerFileBackend, :file}, {LoggerFileBackend, :cloudwatch}, Belfrage.Metrics.CrashTracker]

config :logger, :file,
  path: System.get_env("LOG_PATH"),
  format: {Belfrage.Logger.Formatter, :app},
  level: :error,
  metadata: :all

config :logger, :cloudwatch,
  path: System.get_env("LOG_PATH_CLOUDWATCH"),
  format: {Belfrage.Logger.Formatter, :cloudwatch},
  level: :warn,
  metadata: :all,
  metadata_filter: [cloudwatch: true]
