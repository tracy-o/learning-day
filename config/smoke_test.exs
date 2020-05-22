use Mix.Config

import_config "test.exs"

config :belfrage,
  routefile: Routes.RoutefileMock

config :smoke,
  header: %{
    header_belfrage: %{:id => "bid", :value => "www"},
    header_bruce: %{:id => "bid", :value => "bruce"},
    header_cedric: %{:id => "bid", :value => "cedric"}
  },
  test: %{
    endpoint_belfrage: "https://www.belfrage.test.api.bbc.co.uk",
    endpoint_gtm: "https://www.test.bbc.co.uk",
    endpoint_gtm_com: "https://www.test.bbc.com",
    endpoint_bruce: "https://bruce.belfrage.test.api.bbc.co.uk",
    endpoint_cedric: "https://cedric.belfrage.test.api.bbc.co.uk",
    endpoint_pal: "https://pal.test.bbc.co.uk"
  },
  live: %{
    endpoint_belfrage: "https://www.belfrage.api.bbc.co.uk",
    endpoint_gtm: "https://www.bbc.co.uk",
    endpoint_gtm_com: "https://www.bbc.com",
    endpoint_bruce: "https://bruce.belfrage.api.bbc.co.uk",
    endpoint_cedric: "https://cedric.belfrage.api.bbc.co.uk",
    endpoint_pal: "https://pal.live.bbc.co.uk"
  }
