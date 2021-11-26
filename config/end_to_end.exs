use Mix.Config

import_config "test.exs"

config :belfrage,
  errors_threshold: 100,
  pwa_lambda_function: "arn:aws:lambda:eu-west-1:997052946310:function:test-presentation-layer-lambda",
  origin_simulator: "http://test-compo-1chgcj5evn9oo-f0a64863a5d33db4.elb.eu-west-1.amazonaws.com",
  ccp_s3_bucket: nil,
  short_counter_reset_interval: 5_000,
  long_counter_reset_interval: 60_000,
  mozart_news_endpoint: "https://www.mozart-routing.test.api.bbci.co.uk",
  mozart_weather_endpoint: "https://www.mozart-routing-weather.test.api.bbci.co.uk",
  mozart_sport_endpoint: "https://www.mozart-routing-sport.test.api.bbci.co.uk",
  fabl_endpoint: "https://fabl.test.api.bbci.co.uk",
  programmes_endpoint: "https://programmes-frontend.test.api.bbc.co.uk",
  morph_router_endpoint: "https://morph-router.test.api.bbci.co.uk",
  belfrage: Belfrage,
  monitor_api: Belfrage.MonitorMock,
  machine_gun: Belfrage.Clients.HTTP.MachineGun,
  aws: Belfrage.AWS,
  file_io: Belfrage.Helpers.FileIO,
  expiry_validator: Belfrage.Authentication.Validator.Expiry,
  event: Belfrage.Event
