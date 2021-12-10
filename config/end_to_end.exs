use Mix.Config

import_config "test.exs"

config :belfrage,
  pwa_lambda_function: "arn:aws:lambda:eu-west-1:997052946310:function:test-presentation-layer-lambda",
  mozart_news_endpoint: "https://www.mozart-routing.test.api.bbci.co.uk",
  fabl_endpoint: "https://fabl.test.api.bbci.co.uk",
  monitor_api: Belfrage.MonitorMock,
  file_io: Belfrage.Helpers.FileIO
