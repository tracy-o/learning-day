defmodule Belfrage.Transformers.RssFeedRedirect do
  use Belfrage.Transformers.Transformer

  def call(rest, struct) do
    case should_redirect?(struct.request.subdomain) do
      true -> redirect(struct)
      _ -> then_do(rest, struct)
    end
  end

  defp should_redirect?(subdomain), do: subdomain != "feeds"

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
