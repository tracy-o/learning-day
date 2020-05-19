use Mix.Config

import_config "test.exs"

config :belfrage,
  routefile: Routes.RoutefileMock

config :smoke,
  opts: %{
    endpoint_belfrage: "https://www.belfrage.test.api.bbc.co.uk",
    endpoint_gtm: "https://www.test.bbc.co.uk",
    endpoint_gtm_com: "https://www.test.bbc.com",
    endpoint_bruce: "https://bruce.belfrage.test.api.bbc.co.uk",
    endpoint_cedric: "https://cedric.belfrage.test.api.bbc.co.uk",
    header_belfrage: %{:id => "bid", :value => "www"},
    header_bruce: %{:id => "bid", :value => "bruce"},
    header_cedric: %{:id => "bid", :value => "cedric"}
  }
