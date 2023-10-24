defmodule Belfrage.PreflightTransformers.NewsTopicsPlatformDiscriminator do
  @moduledoc """
  Alters the Platform for a subset of News Topics IDs that need to be served by Mozart.
  """
  use Belfrage.Behaviours.Transformer
  alias Belfrage.PreflightTransformers.NewsTopicsPlatformDiscriminator.NewsTopicIds
  alias Belfrage.Envelope.Private

  @impl Transformer
  def call(envelope) do
    cond do
      is_mozart_topic?(envelope) ->
        set_platform(envelope)

      is_id_guid?(envelope) ->
        set_platform(envelope)

      has_slug?(envelope) ->
        redirect(envelope)

      true ->
        maybe_set_platform(envelope)
    end
  end

  defp set_platform(envelope) do
    {:ok, Envelope.add(envelope, :private, %{platform: "MozartNews"})}
  end

  defp redirect(envelope) do
    {
      :stop,
      Envelope.add(envelope, :response, %{
        http_status: 301,
        headers: %{
          "location" => "/news/topics/#{envelope.request.path_params["id"]}",
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, stale-while-revalidate=10, max-age=60"
        },
        body: "Redirecting"
      })
    }
  end

  defp maybe_set_platform(envelope = %Envelope{private: %Private{platform: nil}}),
    do: {:ok, Envelope.add(envelope, :private, %{platform: "Webcore"})}

  defp maybe_set_platform(envelope = %Envelope{private: %Private{platform: _platform}}), do: {:ok, envelope}

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
