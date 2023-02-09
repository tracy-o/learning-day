defmodule Belfrage.RequestTransformers.NewsTopicsPlatformDiscriminator do
  @moduledoc """
  Alters the Platform for a subset of News Topics IDs that need to be served by Mozart.
  """
  use Belfrage.Behaviours.Transformer
  alias Belfrage.RequestTransformers.NewsTopicsPlatformDiscriminator.NewsTopicIds

  @impl Transformer
  def call(envelope) do
    cond do
      is_mozart_topic?(envelope) or is_id_guid?(envelope) ->
        envelope =
          Envelope.add(envelope, :private, %{
            platform: "MozartNews",
            origin: Application.get_env(:belfrage, :mozart_news_endpoint),
            personalised_route: false,
            personalised_request: false
          })

        {:ok, envelope, {:replace, ["CircuitBreaker"]}}

      not is_mozart_topic?(envelope) and has_slug?(envelope) ->
        {
          :stop,
          Envelope.add(envelope, :response, %{
            http_status: 302,
            headers: %{
              "location" => "/news/topics/#{envelope.request.path_params["id"]}",
              "x-bbc-no-scheme-rewrite" => "1",
              "cache-control" => "public, stale-while-revalidate=10, max-age=60"
            },
            body: "Redirecting"
          })
        }

      true ->
        {:ok, envelope}
    end
  end

  defp is_mozart_topic?(envelope) do
    envelope.request.path_params["id"] in NewsTopicIds.get()
  end

  defp is_id_guid?(envelope) do
    String.match?(
      envelope.request.path_params["id"],
      ~r/^[a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12}$/
    )
  end

  defp has_slug?(envelope) do
    Map.has_key?(envelope.request.path_params, "slug")
  end
end
