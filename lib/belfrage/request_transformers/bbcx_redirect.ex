defmodule Belfrage.RequestTransformers.BBCXRedirect do
  @moduledoc """
  Does the mapping between bbcx only routes to routes available on domestic platforms
  """
  use Belfrage.Behaviours.Transformer

  alias Belfrage.{Envelope, Brands}

  @bbcx_redirect_mapping %{
    "/business" => "/news/business",
    "/business/c-suite" => "/news/business",
    "/business/future-of-business" => "/news/business",
    "/business/global-business" => "/news/business",
    "/business/technology-of-business" => "/news/business-11428889",
    "/business/us-canada-business" => "/news/business",
    "/culture/art" => "/culture/columns/art",
    "/culture/books" => "/culture/tags/books",
    "/culture/entertainment-news" => "/news/entertainment_and_arts",
    "/culture/film-tv" => "/culture/columns/film",
    "/future-planet" => "/future",
    "/future-planet/climate-news" => "/future",
    "/future-planet/solutions" => "/future",
    "/future-planet/environment" => "/future",
    "/innovation" => "/news/technology",
    "/innovation/tech" => "/news/technology",
    "/innovation/science" => "/news/technology",
    "/innovation/artificial-intelligence" => "/news/technology",
    "/innovation/future-now" => "/news/technology",
    "/live" => "/news",
    "/news/long_reads" => "/news/the_reporters",
    "/news/us-canada" => "/news/world/us_and_canada",
    "/news/war-in-ukraine" => "/news/world-60525350",
    "/travel/adventures" => "/travel/columns/adventure-experience",
    "/travel/cultural-experiences" => "/travel/columns/culture-identity",
    "/travel/history-heritage" => "/travel/tags/history",
    "/travel/specialist" => "/travel/columns/the-specialist",
    "/video" => "/reel"
  }

  @default_route "/"

  @impl Transformer
  def call(envelope) do
    if Brands.is_bbcx?(envelope) do
      {:ok, envelope}
    else
      redirect(envelope)
    end
  end

  defp redirect(envelope) do
    {
      :stop,
      Envelope.add(envelope, :response, %{
        http_status: 302,
        headers: %{
          "location" => Map.get(@bbcx_redirect_mapping, envelope.request.path, @default_route),
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, max-age=60"
        }
      })
    }
  end
end
