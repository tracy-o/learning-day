defmodule Belfrage.Transformers.RssFeedRedirect do
  use Belfrage.Transformers.Transformer

  def call(rest, struct) do
    if struct.request.subdomain == "feeds" do
      then_do(rest, struct)
    else
      redirect(struct)
    end
  end

  defp redirect(struct) do
    {
      :redirect,
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
