defmodule Belfrage.RequestTransformers.PersonalisedAccountIsLoggedIn do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Helpers.QueryParams

  @impl Transformer
  def call(envelope) do
    if envelope.user_session.authenticated and envelope.user_session.valid_session do
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
    ptrt =
      IO.iodata_to_binary([
        "https://",
        request.host,
        "/foryou"
      ])

    query_params = %{ptrt: ptrt}

    env =
      case request.host do
        "www.test.bbc.co.uk" -> "test."
        _ -> ""
      end

    IO.iodata_to_binary([
      to_string(request.scheme),
      "://",
      "session.",
      env,
      "bbc.co.uk",
      "/session",
      QueryParams.encode(query_params)
    ])
  end
end
