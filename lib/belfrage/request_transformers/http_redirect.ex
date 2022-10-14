defmodule Belfrage.RequestTransformers.HTTPredirect do
  alias Belfrage.Helpers.QueryParams
  use Belfrage.Transformer

  @impl true
  def call(_rest, struct = %Struct{request: %Struct.Request{scheme: :http}}) do
    redirect_url =
      "https://" <> struct.request.host <> struct.request.path <> QueryParams.encode(struct.request.query_params)

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

  @impl true
  def call(rest, struct), do: then_do(rest, struct)
end
