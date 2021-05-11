use Mix.Config

import_config "test.exs"

config :smoke,
  ignore_specs: ["ProxyPass", "ArchiveArticles", "NewsSearch"],
  endpoint_to_stack_id_mapping: %{
    "belfrage" => %{:id => "bid", :value => "www"},
    "bruce-belfrage" => %{:id => "bid", :value => "bruce"},
    "cedric-belfrage" => %{:id => "bid", :value => "cedric"},
    "sally-belfrage" => %{:id => "bid", :value => "sally"}
  },
  test: %{
    "belfrage" => "www.belfrage.test.api.bbc.co.uk",
    "bruce-belfrage" => "bruce.belfrage.test.api.bbc.co.uk",
    "sally-belfrage" => "sally.belfrage.test.api.bbc.co.uk",
    "cedric-belfrage" => "cedric.belfrage.test.api.bbc.co.uk"
  },
  live: %{
    "belfrage" => "www.belfrage.api.bbc.co.uk",
    "bruce-belfrage" => "bruce.belfrage.api.bbc.co.uk",
    "sally-belfrage" => "sally.belfrage.api.bbc.co.uk",
    "cedric-belfrage" => "cedric.belfrage.api.bbc.co.uk"
  }
