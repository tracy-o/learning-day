defmodule Belfrage.RequestTransformers.WorldServiceRedirect do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Helpers.QueryParams

  @impl Transformer
  def call(envelope = %Envelope{request: %Envelope.Request{scheme: :http}}) do
    redirect(redirect_url(envelope.request), envelope)
  end

  def call(envelope) do
    case should_redirect?(envelope.request.host) do
      true -> redirect(redirect_url(envelope.request), envelope)
      false -> {:ok, envelope}
    end
  end

  def redirect_url(request) do
    "https://" <>
      String.replace(request.host, ".co.uk", ".com") <> request.path <> QueryParams.encode(request.query_params)
  end

  def redirect(redirect_url, envelope) do
    {
      :stop,
      Envelope.add(envelope, :response, %{
        http_status: 302,
        headers: %{
          "location" => redirect_url,
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, stale-while-revalidate=10, max-age=60"
        },
        body: "Redirecting"
      })
    }
  end

  defp should_redirect?(host) do
    String.ends_with?(host, ".co.uk") and not String.contains?(host, ".api.")
  end
end
