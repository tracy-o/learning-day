defmodule Belfrage.Transformers.NewsTopicsPlatformDiscriminatorTransition do
  @moduledoc """
  Alters the Platform for a subset of News Topics IDs that need to be served by Mozart.
  """
  use Belfrage.Transformers.Transformer
  alias Belfrage.Transformers.NewsTopicsPlatformDiscriminator.NewsTopicIds

  @mozart_news_topic_ids NewsTopicIds.get()

  def call(
        _rest,
        struct = %Struct{request: %Struct.Request{path_params: %{"id" => id, "slug" => _slug}}}
      ) do
    if id in @mozart_news_topic_ids do
      then(
        ["CircuitBreaker"],
        Struct.add(struct, :private, %{
          platform: MozartNews
        })
      )
    else
      {
        :redirect,
        Struct.add(struct, :response, %{
          http_status: 302,
          headers: %{
            "location" => "/news/topics/#{id}",
            "x-bbc-no-scheme-rewrite" => "1",
            "cache-control" => "public, stale-while-revalidate=10, max-age=60"
          },
          body: "Redirecting"
        })
      }
    end
  end

  def call(_rest, struct = %Struct{request: %Struct.Request{path_params: %{"id" => id}}}) do
    if id in @mozart_news_topic_ids do
      then(
        ["CircuitBreaker"],
        Struct.add(struct, :private, %{
          platform: MozartNews
        })
      )
    else
      then([], struct)
    end
  end
end
