defmodule Belfrage.Transformers.SportRssRedirect do
  use Belfrage.Transformers.Transformer

  def call(rest, struct) do
    case should_redirect?(struct.request.host) do
      true -> redirect(redirect_url(struct.request), struct)
      _ -> then_do(rest, struct)
    end
  end

  defp redirect_url(request) do
    "https://feeds.bbci.co.uk" <> request.path
  end

  defp redirect(redirect_url, struct) do
    {
      :redirect,
      Struct.add(struct, :response, %{
        http_status: 301,
        headers: %{
          "location" => redirect_url,
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, max-age=60"
        },
        body: "Redirecting"
      })
    }
  end

  defp should_redirect?(host) do
    host == "www.bbc.co.uk"
  end
end
