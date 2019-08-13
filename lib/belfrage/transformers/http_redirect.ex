defmodule Belfrage.Transformers.HTTPredirect do
  alias Belfrage.Helpers.QueryParams
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{scheme: :http}}) do
    redirect_url =
      "https://" <> struct.request.host <> struct.request.path <> QueryParams.parse(struct.request.query_params)

    struct =
      Struct.add(struct, :response, %{
        http_status: 302,
        headers: %{"location" => redirect_url},
        body: "Redirecting"
      })

    {:redirect, struct}
  end

  @impl true
  def call(rest, struct) do
    then(rest, struct)
  end
end