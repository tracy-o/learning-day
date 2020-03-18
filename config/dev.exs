use Mix.Config

config :belfrage,
  origin_simulator: "http://test-compo-1chgcj5evn9oo-f0a64863a5d33db4.elb.eu-west-1.amazonaws.com",
  pwa_lambda_function: "arn:aws:lambda:eu-west-1:997052946310:function:test-presentation-layer-lambda",
  webcore_lambda_role_arn: "webcore-lambda-role-arn",
  mozart_endpoint: "https://www.mozart-routing.test.api.bbci.co.uk",
  pal_endpoint: "https://pal.test.bbc.co.uk",
  fabl_endpoint: "https://fabl.test.api.bbci.co.uk",
  production_environment: "test",
  preview_mode: "off",
  credential_strategy: Belfrage.Credentials.LocalDev,
  dials_location: "test/support/resources/dials.json",
  session_token: System.get_env("AWS_SESSION_TOKEN"),
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
  stack_name: "local-dev-belfrage-stack"

config :belfrage, :benchmark,
  dir: "benchmark",
  namespace: Benchmark

config :ex_metrics,
  send_metrics: false
