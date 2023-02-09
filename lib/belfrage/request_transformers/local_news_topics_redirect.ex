defmodule Belfrage.RequestTransformers.LocalNewsTopicsRedirect do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.RequestTransformers.LocalNewsTopicsRedirect.LocationTopicMappings

  @impl Transformer
  def call(envelope) do
    cond do
      is_local_news?(envelope) and topic_id(envelope.request.path_params) ->
        location = topic_id_location(envelope.request)
        redirect(envelope, location)

      is_local_news?(envelope) ->
        redirect(envelope, "/news/localnews")

      true ->
        {:ok, envelope}
    end
  end

  defp redirect(envelope, location) do
    {
      :stop,
      Envelope.add(envelope, :response, %{
        http_status: 302,
        headers: %{
          "location" => location,
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, stale-while-revalidate=10, max-age=60"
        },
        body: "Redirecting"
      })
    }
  end

  defp is_local_news?(envelope) do
    String.starts_with?(envelope.request.path, "/news/localnews/")
  end

  defp topic_id(path_params = %{}) do
    path_params
    |> Map.get("location_id_and_name")
    |> String.split("-")
    |> List.first()
    |> LocationTopicMappings.get_topic_id()
  end

  defp topic_id_location(request = %Envelope.Request{}) do
    "/news/topics/#{topic_id(request.path_params)}"
  end
end
