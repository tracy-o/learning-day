use Mix.Config

[
  {"WEBCORE_LAMBDA_ROLE_ARN", :default},
  {"PWA_LAMBDA_FUNCTION", :default},
  {"MOZART_NEWS_ENDPOINT", :default},
  {"MOZART_WEATHER_ENDPOINT", :default},
  {"MOZART_SPORT_ENDPOINT", :default},
  {"FABL_ENDPOINT", :default},
  {"PRODUCTION_ENVIRONMENT", :default},
  {"PREVIEW_MODE", :default},
  {"STACK_NAME", :default},
  {"STACK_ID", :default},
  {"CCP_S3_BUCKET", :default},
  {"ACCOUNT_ISS", :custom},
  {"ACCOUNT_JWK_URI", :custom},
  {"SESSION_URL", :custom},
  {"IDCTA_CONFIG_URI", :custom}
]
|> Enum.each(fn {config_key, set_type} ->
  if System.get_env(config_key) == nil do
    raise "Config not set in environment: #{config_key}"
  end

  if set_type == :default do
    config :belfrage,
           Keyword.new([{String.to_atom(String.downcase(config_key)), System.get_env(config_key)}])
  end
end)

config :belfrage, authentication: %{
  "iss" => System.get_env("ACCOUNT_ISS"),
  "aud" => "Account",
  "account_jwk_uri" => System.get_env("ACCOUNT_JWK_URI"),
  "session_url" => System.get_env("SESSION_URL"),
  "idcta_config_uri" => System.get_env("IDCTA_CONFIG_URI")
}
