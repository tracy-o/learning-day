defmodule Belfrage.Transformers.LocalNewsTopicsRedirect do
  use Belfrage.Transformers.Transformer
  alias Belfrage.Transformers.LocalNewsTopicsRedirect.LocationTopicMappings

  @impl true
  def call(rest, struct) do
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
      then_do(rest, struct)
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
    IO.iodata_to_binary([
      to_string(request.scheme),
      "://",
      request.host,
      "/news/topics/#{topic_id(request.path_params)}",
      Belfrage.Helpers.QueryParams.encode(request.query_params)
    ])
  end
end
