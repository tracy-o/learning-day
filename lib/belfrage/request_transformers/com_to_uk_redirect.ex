defmodule Belfrage.RequestTransformers.ComToUKRedirect do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope) do
    case String.ends_with?(envelope.request.host, "bbc.com") do
      true -> {:stop, Envelope.add(envelope, :response, make_redirect_resp(envelope))}
      false -> {:ok, envelope}
    end
  end

  defp make_redirect_resp(envelope) do
    %{
      http_status: 302,
      headers: %{
        "location" => redirect_url(envelope.request),
        "x-bbc-no-scheme-rewrite" => "1",
        "cache-control" => "public, stale-while-revalidate=10, max-age=60"
      },
      body: "Redirecting"
    }
  end

  defp redirect_url(request) do
    IO.iodata_to_binary([
      to_string(request.scheme),
      "://",
      String.replace(request.host, "bbc.com", "bbc.co.uk"),
      request.path,
      Belfrage.Helpers.QueryParams.encode(request.query_params)
    ])
  end
end
