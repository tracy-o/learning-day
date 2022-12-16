defmodule Belfrage.RequestTransformers.RssFeedRedirect do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(struct) do
    if struct.request.subdomain == "feeds" do
      {:ok, struct}
    else
      redirect(struct)
    end
  end

  defp redirect(struct) do
    {
      :stop,
      Struct.add(struct, :response, %{
        http_status: 302,
        headers: %{
          "location" => "https://feeds.bbci.co.uk" <> struct.request.path,
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, max-age=60"
        },
        body: "Redirecting"
      })
    }
  end
end
