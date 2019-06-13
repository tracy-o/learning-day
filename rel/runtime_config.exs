use Mix.Config

["INSTANCE_ROLE_NAME", "WEBCORE_LAMBDA_NAME_PROGRESSIVE_WEB_APP", "WEBCORE_LAMBDA_ROLE_ARN"]
|> Enum.each(fn config_key ->
  if System.get_env(config_key) == nil do
    raise "Config not set in environment: #{config_key}"
  end

  config :ingress,
         Keyword.new([{String.to_atom(String.downcase(config_key)), System.get_env(config_key)}])
end)
