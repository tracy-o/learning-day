defmodule Belfrage.Transformers.WorldServiceRedirect do
  alias Belfrage.Helpers.QueryParams
  use Belfrage.Transformers.Transformer

  @impl true
  def call(_rest, struct) do
    redirect_url =
      "https://" <>
        String.replace(struct.request.host, ".co.uk", ".com") <>
        struct.request.path <> QueryParams.parse(struct.request.query_params)

    struct =
      Struct.add(struct, :response, %{
        http_status: 302,
        headers: %{
          "location" => redirect_url,
          "X-BBC-No-Scheme-Rewrite" => "1"
        },
        body: "Redirecting"
      })

    {:redirect, struct}
  end
end
