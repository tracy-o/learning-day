use Mix.Config

[
  {"WEBCORE_LAMBDA_ROLE_ARN", :required},
  {"PWA_LAMBDA_FUNCTION", :required},
  {"MOZART_ENDPOINT", :required},
  {"PAL_ENDPOINT", :required},
  {"FABL_ENDPOINT", :required},
  {"PRODUCTION_ENVIRONMENT", :required},
  {"PREVIEW_MODE", :required},
  {"STACK_NAME", :required},
  {"STACK_ID", :required},
  {"CCP_S3_BUCKET", :required},
]
|> Enum.each(fn {config_key, importance} ->
  if System.get_env(config_key) == nil and importance != :optional do
    raise "Config not set in environment: #{config_key}"
  end

  config :belfrage,
         Keyword.new([{String.to_atom(String.downcase(config_key)), System.get_env(config_key)}])
end)

config :belfrage, authentication: %{
  "iss" => System.get_env!("ACCOUNT_ISS"),
  "aud" => "Account",
  "account_jwk_uri" => System.get_env!("ACCOUNT_JWK_URI")
}
