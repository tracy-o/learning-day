defmodule Belfrage.ResponseTransformers.ClassicAppCacheControl do
  alias Belfrage.Struct
  @behaviour Belfrage.Behaviours.ResponseTransformer

  @doc """
  If the request is a classic app domain this overrides the cache control to be a minimum of 60s for public cacheability
  """
  @impl true
  def call(
        struct = %Struct{
          request: %Struct.Request{subdomain: subdomain},
          response: %Struct.Response{
            cache_directive: %Belfrage.CacheControl{cacheability: cacheability, max_age: max_age}
          }
        }
      )
      when subdomain in ["news-app-classic", "news-app-global-classic", "news-app-ws-classic"] do
    if cacheability == "public" && max_age < 60 do
      cache_directive = Map.put(struct.response.cache_directive, :max_age, 60)

      Struct.add(struct, :response, %{
        cache_directive: cache_directive
      })
    else
      struct
    end
  end

  @impl true
  def call(struct = %Struct{}), do: struct
end
