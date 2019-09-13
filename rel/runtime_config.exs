use Mix.Config

[
  "WEBCORE_LAMBDA_ROLE_ARN",
  "PWA_LAMBDA_FUNCTION",
  "API_LAMBDA_FUNCTION",
  "SERVICE_WORKER_LAMBDA_FUNCTION",
  "PREVIEW_PWA_LAMBDA_FUNCTION",
  "PREVIEW_API_LAMBDA_FUNCTION",
  "PREVIEW_SERVICE_WORKER_LAMBDA_FUNCTION",
  "PRODUCTION_ENVIRONMENT"
]
|> Enum.each(fn config_key ->
  if System.get_env(config_key) == nil do
    raise "Config not set in environment: #{config_key}"
  end

  config :belfrage,
         Keyword.new([{String.to_atom(String.downcase(config_key)), System.get_env(config_key)}])
end)
