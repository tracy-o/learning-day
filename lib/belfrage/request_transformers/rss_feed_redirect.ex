defmodule Belfrage.RequestTransformers.RssFeedRedirect do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope) do
    if envelope.request.subdomain == "feeds" do
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
          "location" => "https://feeds.bbci.co.uk" <> envelope.request.path,
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, max-age=60"
        },
        body: "Redirecting"
      })
    }
  end
end
