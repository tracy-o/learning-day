use Mix.Config

# karanga_endpoint: "https://broker.karanga.test.api.bbci.co.uk",
#   philippa_endpoint: "https://philippa-producer.test.api.bbci.co.uk",
#   trevor_endpoint: "https://trevor-producer.test.api.bbci.co.uk",

[
  {"WEBCORE_LAMBDA_ROLE_ARN", :default},
  {"PWA_LAMBDA_FUNCTION", :default},
  {"MOZART_NEWS_ENDPOINT", :default},
  {"MOZART_WEATHER_ENDPOINT", :default},
  {"MOZART_SPORT_ENDPOINT", :default},
  {"PROGRAMMES_ENDPOINT", :default},
  {"FABL_ENDPOINT", :default},
  {"SIMORGH_ENDPOINT", :default},
  {"MORPH_ROUTER_ENDPOINT", :default},
  {"KARANGA_ENDPOINT", :default},
  {"ARES_ENDPOINT", :default},
  {"PHILIPPA_ENDPOINT", :default},
  {"TREVOR_ENDPOINT", :default},
  {"WALTER_ENDPOINT", :default},
  {"PRODUCTION_ENVIRONMENT", :default},
  {"PREVIEW_MODE", :default},
  {"STACK_NAME", :default},
  {"STACK_ID", :default},
  {"CCP_S3_BUCKET", :default},
  {"ACCOUNT_JWK_URI", :custom},
  {"SESSION_URL", :custom},
  {"IDCTA_CONFIG_URI", :custom},
  {"MVT_SLOTS_URI", :custom}
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

config :belfrage,
  authentication: %{
    "account_jwk_uri" => System.get_env("ACCOUNT_JWK_URI"),
    "session_url" => System.get_env("SESSION_URL"),
    "idcta_config_uri" => System.get_env("IDCTA_CONFIG_URI"),
    "jwt_expiry_window" => 4200
  },
  mvt: %{
    slots_file_location: System.get_env("MVT_SLOTS_URI")
  }
