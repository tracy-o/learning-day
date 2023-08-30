defmodule Belfrage.RequestTransformers.PersonalisedAccountIsLoggedIn do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Helpers.QueryParams

  @impl Transformer
  def call(envelope) do
    if envelope.user_session.authenticated do
      {:ok, envelope}
    else
      {:stop, Envelope.add(envelope, :response, make_redirect_resp(envelope))}
    end
  end

  defp make_redirect_resp(envelope) do
    %{
      http_status: 302,
      headers: %{
        "location" => redirect_url(envelope.request),
        "x-bbc-no-scheme-rewrite" => "1",
        "cache-control" => "public, stale-if-error=90, stale-while-revalidate=30, max-age=60"
      },
      body: ""
    }
  end

  defp redirect_url(request) do
    query_params = %{ptrt: "https://www.bbc.co.uk/foryou"}

    IO.iodata_to_binary([
      to_string(request.scheme),
      "://",
      request.host,
      "/signin",
      QueryParams.encode(query_params)
    ])
  end
end
