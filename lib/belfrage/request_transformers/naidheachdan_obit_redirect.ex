defmodule Belfrage.RequestTransformers.NaidheachdanObitRedirect do
  alias Belfrage.Helpers.QueryParams
  use Belfrage.Behaviours.Transformer

  @dial Application.compile_env(:belfrage, :dial)

  @impl Transformer
  def call(envelope) do
    case @dial.state(:obit_mode) do
      "on" -> redirect(envelope)
      "off" -> {:ok, envelope}
    end
  end

  defp redirect(envelope) do
    redirect_url = "https://" <> envelope.request.host <> "/news" <> QueryParams.encode(envelope.request.query_params)

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
end
