use Mix.Config

config :belfrage,
  origin_simulator: "http://test-compo-1chgcj5evn9oo-f0a64863a5d33db4.elb.eu-west-1.amazonaws.com",
  pwa_lambda_function: "arn:aws:lambda:eu-west-1:997052946310:function:test-presentation-layer-lambda",
  webcore_lambda_role_arn: "webcore-lambda-role-arn",
  mozart_news_endpoint: "https://www.mozart-routing.test.api.bbci.co.uk",
  mozart_weather_endpoint: "https://www.mozart-routing-weather.test.api.bbci.co.uk",
  mozart_sport_endpoint: "https://www.mozart-routing-sport.test.api.bbci.co.uk",
  fabl_endpoint: "https://fabl.test.api.bbci.co.uk",
  programmes_endpoint: "https://programmes-frontend.test.api.bbc.co.uk",
  production_environment: "test",
  preview_mode: "off",
  webcore_credentials_source: Belfrage.Services.Webcore.Credentials.Env,
  webcore_credentials_polling_enabled: false,
  webcore_credentials_session_token: System.get_env("AWS_SESSION_TOKEN"),
  webcore_credentials_access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  webcore_credentials_secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  dials_location: "test/support/resources/dials.json",
  not_found_page: "test/support/resources/not-found.html",
  not_supported_page: "test/support/resources/not-supported.html",
  internal_error_page: "test/support/resources/internal-error.html",
  jwk_polling_enabled: false

config :belfrage, :benchmark,
  dir: "benchmark",
  namespace: Benchmark

config :logger, truncate: :infinity
