defmodule Belfrage.RequestTransformers.NaidheachdanObitRedirect do
  alias Belfrage.Helpers.QueryParams
  use Belfrage.Behaviours.Transformer

  @dial Application.get_env(:belfrage, :dial)

  @impl Transformer
  def call(struct) do
    case @dial.state(:obit_mode) do
      "on" -> redirect(struct)
      "off" -> {:ok, struct}
    end
  end

  defp redirect(struct) do
    redirect_url = "https://" <> struct.request.host <> "/news" <> QueryParams.encode(struct.request.query_params)

    {
      :stop,
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
