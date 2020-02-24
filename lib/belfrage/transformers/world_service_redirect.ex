defmodule Belfrage.Transformers.WorldServiceRedirect do
  alias Belfrage.Helpers.QueryParams
  use Belfrage.Transformers.Transformer

  @impl true
  def call(_rest, struct = %Struct{request: %Struct.Request{scheme: :http}}) do
    redirect(redirect_url(struct.request), struct)
  end

  def call(rest, struct) do
    case String.contains?(struct.request.host, ".co.uk") do
      true -> redirect(redirect_url(struct.request), struct)
      _    -> then(rest, struct)
    end
  end

  def redirect_url(request) do
    "https://" <> String.replace(request.host, ".co.uk", ".com") <> request.path <> QueryParams.parse(request.query_params)
  end

  def redirect(redirect_url, struct) do
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
