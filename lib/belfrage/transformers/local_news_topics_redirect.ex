defmodule Belfrage.Transformers.LocalNewsTopicsRedirect do
  use Belfrage.Transformers.Transformer
  alias Belfrage.Transformers.LocalNewsTopicsRedirect.LocationTopicMappings
  alias Belfrage.Helpers.QueryParams

  @impl true
  def call(_rest, struct) do
    if redirect?(struct) do
      {
        :redirect,
        Struct.add(struct, :response, %{
          http_status: 302,
          headers: %{
            "location" => redirect(struct.request),
            "x-bbc-no-scheme-rewrite" => "1",
            "cache-control" => "public, stale-while-revalidate=10, max-age=60"
          },
          body: "Redirecting"
        })
      }
    else
      {:stop_pipeline, Struct.put_status(struct, 404)}
    end
  end

  def redirect?(struct) do
    String.starts_with?(struct.request.path, "/news/localnews/") and topic_id(struct.request.path_params)
  end

  defp topic_id(path_params = %{}) do
    path_params
    |> Map.get("location_id_and_name")
    |> String.split("-")
    |> List.first()
    |> LocationTopicMappings.get_topic_id()
  end

  defp redirect(request = %Struct.Request{}) do
    "/news/topics/#{topic_id(request.path_params)}" <> QueryParams.encode(request.query_params)
  end
end
