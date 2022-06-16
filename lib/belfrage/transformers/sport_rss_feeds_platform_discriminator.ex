defmodule Belfrage.Transformers.SportRssFeedsPlatformDiscriminator do
  @moduledoc """
  Alters the Platform for a subset of Sport RSS feeds that need to be served by FABL.
  """
  use Belfrage.Transformers.Transformer

  @fabl_feeds [
    "4d38153b-987e-4497-b959-8be7c968d4d1"
  ]

  def call(rest, struct) do
    if struct.request.path_params["discipline"] in @fabl_feeds do
      struct =
        Struct.add(struct, :private, %{
          platform: Fabl,
          origin: Application.get_env(:belfrage, :fabl_endpoint)
        })
      
      struct =
        Struct.add(struct, :request, %{
          path: "/fd/preview/:name",
          path_params: %{
            "name" => "rss",
          },
          query_params: %{
            "guid" => "4d38153b-987e-4497-b959-8be7c968d4d1",
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
