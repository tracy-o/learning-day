use Mix.Config

[
  {"WEBCORE_LAMBDA_ROLE_ARN", :required},
  {"PWA_LAMBDA_FUNCTION", :required},
  {"PREVIEW_PWA_LAMBDA_FUNCTION", :required},
  {"PRODUCTION_ENVIRONMENT", :required}
]
|> Enum.each(fn {config_key, importance} ->
  if System.get_env(config_key) == nil and importance != :optional do
    raise "Config not set in environment: #{config_key}"
  end

  config :belfrage,
         Keyword.new([{String.to_atom(String.downcase(config_key)), System.get_env(config_key)}])
end)
