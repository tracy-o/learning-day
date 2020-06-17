use Mix.Config

import_config "test.exs"

config :belfrage,
  routefile: Routes.RoutefileMock

config :smoke,
  ignore_specs: ["WorldServiceMundo"],
  endpoint_to_stack_id_mapping: %{
    "belfrage" => %{:id => "bid", :value => "www"},
    "bruce" => %{:id => "bid", :value => "bruce"},
    "cedric" => %{:id => "bid", :value => "cedric"},
    "preview" => %{:id => "bid", :value => "preview"}
  },
  test: %{
    "belfrage" => "www.belfrage.test.api.bbc.co.uk",
    "bruce" => "bruce.belfrage.test.api.bbc.co.uk",
    "cedric" => "cedric.belfrage.test.api.bbc.co.uk",
    "preview" => "int.belfrage-preview.test.api.bbc.co.uk"
  },
  live: %{
    "belfrage" => "www.belfrage.api.bbc.co.uk",
    "bruce" => "bruce.belfrage.api.bbc.co.uk",
    "cedric" => "cedric.belfrage.api.bbc.co.uk"
  }
