defmodule Belfrage.RequestTransformers.DomesticToBBCXRedirect do
  @moduledoc """
  Does the mapping between routes available only on domestic platforms to specified BBCX routes
  """
  use Belfrage.Behaviours.Transformer

  alias Belfrage.Envelope

  @bbcx_redirect_mapping %{
    "/news/world-60525350" => "/news/war-in-ukraine",
    "/news/world/us_and_canada" => "/news/us-canada",
    "/news/topics/cw9l5jelpl1t" => "/business/technology-of-business",
    "/news/business" => "/business",
    "/news/technology" => "/innovation",
    "/news/entertainment_and_arts" => "/culture/entertainment-news",
    "/culture/columns/film" => "/culture/film-tv",
    "/culture/columns/art" => "/culture/art",
    "/culture/tags/books" => "/culture/books",
    "/travel/tags/history" => "/travel/history-heritage",
    "/travel/columns/culture-identity" => "/travel/cultural-experiences",
    "/travel/columns/adventure-experience" => "/travel/adventures",
    "/travel/columns/the-specialist" => "/travel/specialist",
    "/future" => "/future-planet",
    "/future/future-planet" => "/future-planet",
    "/reel" => "/video"
  }

  @impl Transformer
  def call(envelope) do
    if Map.has_key?(@bbcx_redirect_mapping, envelope.request.path) do
      redirect(envelope)
    else
      {:ok, envelope}
    end
  end

  defp redirect(envelope) do
    {
      :stop,
      Envelope.add(envelope, :response, %{
        http_status: 302,
        headers: %{
          "location" => Map.get(@bbcx_redirect_mapping, envelope.request.path),
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, max-age=60"
        }
      })
    }
  end
end
