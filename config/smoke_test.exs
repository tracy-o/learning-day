import Config

import_config "test.exs"

config :belfrage, :smoke,
  ignore_specs: ["ProxyPass", "ArchiveArticles", "NewsSearch"],
  endpoint_to_stack_id_mapping: %{
    "belfrage" => %{:id => "bid", :value => "www"},
    "bruce-belfrage" => %{:id => "bid", :value => "bruce"},
    "cedric-belfrage" => %{:id => "bid", :value => "cedric"},
    "joan-belfrage" => %{:id => "bid", :value => "joan"},
    "sally-belfrage" => %{:id => "bid", :value => "sally"},
    "sydney-belfrage" => %{:id => "bid", :value => "sydney"}
  },
  test: %{
    "belfrage" => "www.belfrage.test.api.bbc.co.uk",
    "bruce-belfrage" => "bruce.belfrage.test.api.bbc.co.uk",
    "cedric-belfrage" => "cedric.belfrage.test.api.bbc.co.uk",
    "joan-belfrage" => "joan.belfrage.test.api.bbc.co.uk",
    "sally-belfrage" => "sally.belfrage.test.api.bbc.co.uk",
    "sydney-belfrage" => "sydney.belfrage.test.api.bbc.co.uk"
  },
  live: %{
    "belfrage" => "www.belfrage.api.bbc.co.uk",
    "bruce-belfrage" => "bruce.belfrage.api.bbc.co.uk",
    "cedric-belfrage" => "cedric.belfrage.api.bbc.co.uk",
    "joan-belfrage" => "joan.belfrage.api.bbc.co.uk",
    "sally-belfrage" => "sally.belfrage.api.bbc.co.uk",
    "sydney-belfrage" => "sydney.belfrage.api.bbc.co.uk"
  }
