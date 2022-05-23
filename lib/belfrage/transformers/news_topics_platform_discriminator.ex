defmodule Belfrage.Transformers.NewsTopicsPlatformDiscriminator do
  @moduledoc """
  Alters the Platform for a subset of News Topics IDs that need to be served by Mozart.
  """
  use Belfrage.Transformers.Transformer
  alias Belfrage.Transformers.NewsTopicsPlatformDiscriminator.NewsTopicIds

  def call(rest, struct) do
    cond do
      is_mozart_topic?(struct) or is_id_guid?(struct) ->
        struct =
          Struct.add(struct, :private, %{
            platform: MozartNews,
            origin: Application.get_env(:belfrage, :mozart_news_endpoint),
            personalised_route: false,
            personalised_request: false
          })

        then_do(["CircuitBreaker"], struct)

      not is_mozart_topic?(struct) and has_slug?(struct) ->
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

      true ->
        then_do(rest, struct)
    end
  end

  defp is_mozart_topic?(struct) do
    struct.request.path_params["id"] in NewsTopicIds.get()
  end

  defp is_id_guid?(struct) do
    String.match?(struct.request.path_params["id"], ~r/^[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}$/)
  end

  defp has_slug?(struct) do
    Map.has_key?(struct.request.path_params, "slug")
  end
end
