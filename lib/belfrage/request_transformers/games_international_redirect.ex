defmodule Belfrage.RequestTransformers.GamesInternationalRedirect do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope) do
    if needs_redirect?(envelope), do: redirect(envelope), else: {:ok, envelope}
  end

  defp redirect(envelope) do
    {
      :stop,
      Envelope.add(envelope, :response, %{
        http_status: 301,
        headers: %{
          "location" => "https://www.bbcchannels.com",
          "cache-control" => "public, stale-while-revalidate=10, max-age=60"
        },
        body: ""
      })
    }
  end

  defp needs_redirect?(%Envelope{request: %Envelope.Request{host: host, is_uk: false, path: "/games"}}) do
    valid_domain?(host)
  end

  defp needs_redirect?(_envelope), do: false

  defp valid_domain?(host), do: String.ends_with?(host, ".bbc.com")
end
