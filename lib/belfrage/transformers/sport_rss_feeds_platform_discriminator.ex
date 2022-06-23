defmodule Belfrage.Transformers.SportRssFeedsPlatformDiscriminator do
  @moduledoc """
  Alters the Platform for a subset of Sport RSS feeds that need to be served by FABL.
  """
  use Belfrage.Transformers.Transformer

  @fabl_feeds [
    "9d794c09-c573-4a97-9a0e-9518888f19ed",
    "65e7e652-4bcc-4d48-a19c-241f58d830ba",
    "311fec37-a12a-46d5-9b6a-f485c7413077",
    "fe2526f0-d352-4a2f-8b03-9b7b692fd3cd",
    "cd988a73-6c41-4690-b785-c8d3abc2d13c",
    "6d2040e9-3e55-4662-b463-4878c42726da",
    "f1125cb0-7114-4b36-b5b9-469864464b31",
    "7f503ae5-3778-4951-b559-ea30ce7bd167",
    "1aa023c9-b945-4bda-8b1c-211f9fe9e05f",
    "5ec63a0c-4a74-43d4-926c-c75789c078c1",
    "9057858a-33bd-425c-891c-a9b072728513",
    "4e1cd8c0-ef81-4cea-a005-ba769e3bb2fb",
    "e3056dd5-434c-4391-a2e4-8e02a31645a7",
    "6a48e77e-3465-4e35-a94b-dac77299838c",
    "c8b2685d-9517-4601-8561-482e2bd67ea9",
    "24e14219-8ae2-4ee7-b180-cad9b0d5bfa2",
    "25734f16-1a36-42e0-879a-8cd4c3275028",
    "2bab7697-c436-4581-87cb-1a9178ad81af",
    "28a3cb5b-a2ea-4283-b58e-d72dc48d6034",
    "414600e4-1cf0-429c-831f-81e1b14b9b78",
    "3ebf9ee6-6037-4fdb-b00f-cca98c6574a3",
    "565d637f-6fb0-4799-8db8-a001978d2222",
    "fe736477-01b6-4020-8b30-36522ac59457",
    "90c95587-a1bb-4a6c-bba1-1c4b72502129",
    "b86ca75b-7f26-4221-9791-37ddc01660dc",
    "87e9eb08-b0b1-4232-a585-3762aea99680",
    "bea1cb38-a492-44e9-8c9e-8865e4a2c014",
    "f0489362-27b3-4200-b0a9-c73c15b9869a",
    "ae6a1e5a-1636-4e8d-8e0e-fac28430e53e",
    "c645646c-0ca5-46c6-96cd-9eb3d9f278d1"
  ]

  def call(rest, struct) do
    if struct.request.path_params["discipline"] in @fabl_feeds do
      struct =
        struct
        |> Struct.add(:private, %{
          platform: Fabl,
          origin: Application.get_env(:belfrage, :fabl_endpoint)
        })
        |> Struct.add(:request, %{
          path: "/fd/rss",
          path_params: %{
            "name" => "rss"
          },
          query_params: %{
            "guid" => struct.request.path_params["discipline"]
          },
          raw_headers: %{
            "ctx-unwrapped" => "1"
          }
        })

      then_do(["CircuitBreaker"], struct)
    else
      then_do(rest, struct)
    end
  end
end
