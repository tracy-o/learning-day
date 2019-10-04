use Mix.Config

[
  {"WEBCORE_LAMBDA_ROLE_ARN", :required},
  {"PWA_LAMBDA_FUNCTION", :required},
  {"API_LAMBDA_FUNCTION", :required},
  {"PREVIEW_PWA_LAMBDA_FUNCTION", :required},
  {"PREVIEW_API_LAMBDA_FUNCTION", :required},
  {"PRODUCTION_ENVIRONMENT", :required},
  {"PLAYGROUND_PWA_LAMBDA_FUNCTION", :optional},
  {"PLAYGROUND_API_LAMBDA_FUNCTION", :optional},
  {"PLAYGROUND_LAMBDA_ROLE_ARN", :optional}
]
|> Enum.each(fn {config_key, importance} ->
  if System.get_env(config_key) == nil and importance != :optional do
    raise "Config not set in environment: #{config_key}"
  end

  config :belfrage,
         Keyword.new([{String.to_atom(String.downcase(config_key)), System.get_env(config_key)}])
end)
