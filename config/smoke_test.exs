use Mix.Config

import_config "test.exs"

config :belfrage,
  routefile: Routes.RoutefileMock

config :smoke,
  ignore_specs: ["Hcraes", "ContainerData", "PageComposition", "PresTest"],
  header: %{
    header_belfrage: %{:id => "bid", :value => "www"},
    header_bruce: %{:id => "bid", :value => "bruce"},
    header_cedric: %{:id => "bid", :value => "cedric"}
  },
  test: %{
    endpoint_belfrage: "www.belfrage.test.api.bbc.co.uk",
    endpoint_gtm: "www.test.bbc.co.uk",
    endpoint_gtm_com: "www.test.bbc.com",
    endpoint_bruce: "bruce.belfrage.test.api.bbc.co.uk",
    endpoint_cedric: "cedric.belfrage.test.api.bbc.co.uk",
    endpoint_pal: "pal.test.bbc.co.uk"
  },
  live: %{
    endpoint_belfrage: "www.belfrage.api.bbc.co.uk",
    endpoint_gtm: "www.bbc.co.uk",
    endpoint_gtm_com: "www.bbc.com",
    endpoint_bruce: "bruce.belfrage.api.bbc.co.uk",
    endpoint_cedric: "cedric.belfrage.api.bbc.co.uk",
    endpoint_pal: "pal.live.bbc.co.uk"
  }
