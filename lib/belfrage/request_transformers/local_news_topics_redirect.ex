defmodule Belfrage.RequestTransformers.LocalNewsTopicsRedirect do
  use Belfrage.Transformer
  alias Belfrage.RequestTransformers.LocalNewsTopicsRedirect.LocationTopicMappings

  @impl true
  def call(rest, struct) do
    cond do
      is_local_news?(struct) and topic_id(struct.request.path_params) ->
        location = topic_id_location(struct.request)
        redirect(struct, location)

      is_local_news?(struct) ->
        redirect(struct, "/news/localnews")

      true ->
        then_do(rest, struct)
    end
  end

  defp redirect(struct, location) do
    {
      :redirect,
      Struct.add(struct, :response, %{
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

  defp is_local_news?(struct) do
    String.starts_with?(struct.request.path, "/news/localnews/")
  end

  defp topic_id(path_params = %{}) do
    path_params
    |> Map.get("location_id_and_name")
    |> String.split("-")
    |> List.first()
    |> LocationTopicMappings.get_topic_id()
  end

  defp topic_id_location(request = %Struct.Request{}) do
    "/news/topics/#{topic_id(request.path_params)}"
  end
end
