defmodule Belfrage.RequestTransformers.DotComRedirect do
  @moduledoc """
  For Dotcom routes with no domestic equivalent redirects domestic users to the homepage
  """
  use Belfrage.Behaviours.Transformer

  alias Belfrage.{Envelope}

  @impl Transformer
  def call(envelope) do
    if envelope.request.is_uk do
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
          "location" => "/",
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, max-age=60"
        }
      })
    }
  end
end
