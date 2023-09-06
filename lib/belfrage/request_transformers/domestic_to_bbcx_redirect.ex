defmodule Belfrage.RequestTransformers.DomesticToBBCXRedirect do
  @moduledoc """
  Does the mapping between routes available only on domestic platforms to specified BBCX routes
  """
  use Belfrage.Behaviours.Transformer

  alias Belfrage.Envelope

  @bbcx_redirect_mapping %{
    "/news/topics/cw9l5jelpl1t" => "/business/technology-of-business"
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
