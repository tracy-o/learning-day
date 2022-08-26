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
          },
          private: %Struct.Private{personalised_request: personalised_request}
        }
      )
      when subdomain in ["news-app-classic", "news-app-global-classic", "news-app-ws-classic"] do
    cond do
      cacheability == "public" && max_age < 60 ->
        cache_directive = Map.put(struct.response.cache_directive, :max_age, 60)

        Struct.add(struct, :response, %{
          cache_directive: cache_directive
        })

      cacheability == "private" && personalised_request == false ->
        cache_directive = %Belfrage.CacheControl{
          cacheability: "public",
          max_age: 60,
          stale_while_revalidate: 60,
          stale_if_error: 90
        }

        Struct.add(struct, :response, %{
          cache_directive: cache_directive
        })

      true ->
        struct
    end
  end

  @impl true
  def call(struct = %Struct{}), do: struct
end
