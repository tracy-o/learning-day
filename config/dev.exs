import Config

config :belfrage,
  origin_simulator: "http://test-compo-1chgcj5evn9oo-f0a64863a5d33db4.elb.eu-west-1.amazonaws.com",
  ccp_s3_bucket: "belfrage-distributed-cache-test",
  pwa_lambda_function: "arn:aws:lambda:eu-west-1:997052946310:function:test-presentation-layer-lambda",
  webcore_lambda_role_arn: "webcore-lambda-role-arn",
  mozart_news_endpoint: "https://www.mozart-routing.test.api.bbci.co.uk",
  mozart_weather_endpoint: "https://www.mozart-routing-weather.test.api.bbci.co.uk",
  mozart_sport_endpoint: "https://www.mozart-routing-sport.test.api.bbci.co.uk",
  ares_endpoint: "https://ares-api.test.api.bbci.co.uk",
  fabl_endpoint: "https://fabl.test.api.bbci.co.uk",
  programmes_endpoint: "https://programmes-frontend.test.api.bbc.co.uk",
  morph_router_endpoint: "https://morph-router.test.api.bbci.co.uk",
  simorgh_endpoint: "http://internal.simorgh.test.api.bbci.co.uk",
  karanga_endpoint: "https://broker.karanga.test.api.bbci.co.uk",
  philippa_endpoint: "https://philippa-producer.test.api.bbci.co.uk",
  trevor_endpoint: "https://trevor-producer.test.api.bbci.co.uk",
  walter_endpoint: "https://walter-producer.test.api.bbci.co.uk",
  production_environment: "test",
  preview_mode: "off",
  webcore_credentials_source: Belfrage.Services.Webcore.Credentials.Env,
  webcore_credentials_session_token: System.get_env("AWS_SESSION_TOKEN"),
  webcore_credentials_access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  webcore_credentials_secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  dials_location: "cosmos/dials_values_dev_env.json"

config :belfrage, :benchmark,
  dir: "benchmark",
  namespace: Benchmark

config :logger, truncate: :infinity

config :libcluster,
  topologies: [
    cluster: [
      # The selected clustering strategy. Required.
      strategy: Cluster.Strategy.Epmd,
      # This is based on how many nodes we'll be starting locally
      config: [hosts: [:"a@127.0.0.1", :"b@127.0.0.1"]]
    ]
  ]
