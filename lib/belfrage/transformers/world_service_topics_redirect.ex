defmodule Belfrage.Transformers.WorldServiceTopicsRedirect do
  alias Belfrage.Helpers.QueryParams
  use Belfrage.Transformers.Transformer

  @impl true
  def call(_rest, struct = %Struct{request: %Struct.Request{scheme: :http}}) do
    redirect(redirect_url(struct.request), struct)
  end

  def call(rest, struct) do
    case should_redirect?(struct.request.host) do
      true -> redirect(redirect_url(struct.request), struct)
      _ -> then_do(rest, struct)
    end
  end

  def redirect_url(request) do
    "https://" <>
      String.replace(request.host, ".co.uk", ".com") <> request.path <> QueryParams.encode(request.query_params)
  end

  def redirect(redirect_url, struct) do
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

  defp should_redirect?(host) do
    String.ends_with?(host, ".co.uk") and not String.contains?(host, ".api.")
  end
end
