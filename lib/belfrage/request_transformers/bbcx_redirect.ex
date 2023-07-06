defmodule Belfrage.RequestTransformers.BBCXRedirect do
  @moduledoc """
  Does the mapping between bbcx only routes to routes available on domestic platforms
  """
  use Belfrage.Behaviours.Transformer

  alias Belfrage.{Envelope, Brands}

  @bbcx_redirect_mapping %{
    "/business" => "/news/business",
    "/business/technology-of-business" => "/news/business-11428889",
    "/news/us-canada" => "/news/world/us_and_canada",
    "/news/war-in-ukraine" => "/news/world-60525350",
    "/news/world/latin-america" => "/news/world/latin_america",
    "/news/world/middle-east" => "/news/world/middle_east",
    "/travel/adventures" => "/travel",
    "/travel/cultural-experiences" => "/travel",
    "/travel/history-heritage" => "/travel",
    "/travel/specialist" => "/travel"
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
