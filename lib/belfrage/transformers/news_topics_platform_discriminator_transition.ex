defmodule Belfrage.Transformers.NewsTopicsPlatformDiscriminatorTransition do
  @moduledoc """
  Alters the Platform for a subset of News Topics IDs that need to be served by Mozart.
  """
  use Belfrage.Transformers.Transformer
  alias Belfrage.Transformers.NewsTopicsPlatformDiscriminator.NewsTopicIds

  def call(rest, struct) do
    cond do
      redirect?(struct) ->
        {
          :redirect,
          Struct.add(struct, :response, %{
            http_status: 302,
            headers: %{
              "location" => "/news/topics/#{struct.request.path_params["id"]}",
              "x-bbc-no-scheme-rewrite" => "1",
              "cache-control" => "public, stale-while-revalidate=10, max-age=60"
            },
            body: "Redirecting"
          })
        }

      to_mozart_news?(struct) ->
        then_do(
          ["CircuitBreaker"],
          Struct.add(struct, :private, %{
            platform: MozartNews,
            origin: Application.get_env(:belfrage, :mozart_news_endpoint),
            personalised_route: false,
            personalised_request: false
          })
        )

      true ->
        then_do(rest, struct)
    end
  end

  defp redirect?(struct) do
    Map.has_key?(struct.request.path_params, "slug") and struct.request.path_params["id"] not in NewsTopicIds.get()
  end

  defp to_mozart_news?(struct) do
    struct.request.path_params["id"] in NewsTopicIds.get()
  end
end
