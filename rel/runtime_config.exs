use Mix.Config

["WEBCORE_LAMBDA_NAME_PROGRESSIVE_WEB_APP", "WEBCORE_LAMBDA_ROLE_ARN", "GRAPHQL_LAMBDA_FUNCTION", "GRAPHQL_LAMBDA_ROLE_ARN",
 "SERVICE_WORKER_LAMBDA_FUNCTION", "SERVICE_WORKER_LAMBDA_ROLE_ARN"]
|> Enum.each(fn config_key ->
  if System.get_env(config_key) == nil do
    raise "Config not set in environment: #{config_key}"
  end

  config :belfrage,
         Keyword.new([{String.to_atom(String.downcase(config_key)), System.get_env(config_key)}])
end)
