defmodule Belfrage.RequestTransformers.NewsAvRedirect do
  use Belfrage.Behaviours.Transformer

  alias Belfrage.Envelope

  @impl Transformer
  def call(
        envelope = %Envelope{
          private: %Envelope.Private{preflight_metadata: preflight_metadata},
          request: %Envelope.Request{path: path, path_params: path_params}
        }
      ) do
    case {is_news_non_av_path?(path, path_params), Map.get(preflight_metadata, "AresData")} do
      {true, "MAP"} ->
        {:stop, Envelope.add(envelope, :response, make_redirect_resp(path_params))}

      _other ->
        {:ok, envelope}
    end
  end

  defp make_redirect_resp(path_params) do
    %{
      http_status: 301,
      headers: %{
        "location" => "/news/av/#{path_params["id"]}",
        "x-bbc-no-scheme-rewrite" => "1",
        "cache-control" => "public, stale-if-error=90, stale-while-revalidate=30, max-age=60"
      }
    }
  end

  defp is_news_non_av_path?(path, path_params) do
    path == "/news/#{path_params["id"]}"
  end
end
