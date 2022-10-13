defmodule Belfrage.RequestTransformers.NaidheachdanObitRedirect do
  alias Belfrage.Helpers.QueryParams
  use Belfrage.Transformer

  @dial Application.get_env(:belfrage, :dial)

  @impl true
  def call(rest, struct) do
    case @dial.state(:obit_mode) do
      "on" -> redirect(struct)
      "off" -> then_do(rest, struct)
    end
  end

  defp redirect(struct) do
    redirect_url = "https://" <> struct.request.host <> "/news" <> QueryParams.encode(struct.request.query_params)

    {
      :redirect,
      Struct.add(struct, :response, %{
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
