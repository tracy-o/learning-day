use Mix.Config

import_config "test.exs"

config :belfrage,
  routefile: Routes.RoutefileMock

config :smoke,
  ignore_specs: ["WorldServiceMundo", "ProxyPass", "NaidheachdanArticlePage", "CymrufywArticlePage"],
  endpoint_to_stack_id_mapping: %{
    "belfrage" => %{:id => "bid", :value => "www"},
    "bruce-belfrage" => %{:id => "bid", :value => "bruce"},
    "cedric-belfrage" => %{:id => "bid", :value => "cedric"},
    "belfrage-preview" => %{:id => "bid", :value => "preview"}
  },
  test: %{
    "belfrage" => "www.belfrage.test.api.bbc.co.uk",
    "bruce-belfrage" => "bruce.belfrage.test.api.bbc.co.uk",
    "cedric-belfrage" => "cedric.belfrage.test.api.bbc.co.uk",
    "belfrage-preview" => "int.belfrage-preview.test.api.bbc.co.uk"
  },
  live: %{
    "belfrage" => "www.belfrage.api.bbc.co.uk",
    "bruce-belfrage" => "bruce.belfrage.api.bbc.co.uk",
    "cedric-belfrage" => "cedric.belfrage.api.bbc.co.uk"
  }
