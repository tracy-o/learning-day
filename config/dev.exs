use Mix.Config

config :belfrage,
  origin_simulator: "http://test-compo-1chgcj5evn9oo-f0a64863a5d33db4.elb.eu-west-1.amazonaws.com",
  pwa_lambda_function: "pwa-lambda-function",
  preview_pwa_lambda_function:
    "arn:aws:lambda:eu-west-1:134209033928:function:webcore-playground-test-webcore-playground-pwa",
  webcore_lambda_role_arn: "webcore-lambda-role-arn",
  mozart_endpoint: "https://www.mozart-routing.test.api.bbci.co.uk",
  production_environment: "test",
  credential_strategy: Belfrage.Credentials.LocalDev,
  dials_location: "test/support/resources/dials.json",
  session_token: System.get_env("AWS_SESSION_TOKEN"),
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY")

config :ex_metrics,
  send_metrics: false
