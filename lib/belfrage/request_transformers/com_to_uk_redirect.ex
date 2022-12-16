defmodule Belfrage.RequestTransformers.ComToUKRedirect do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(struct) do
    case String.ends_with?(struct.request.host, "bbc.com") do
      true -> {:stop, Struct.add(struct, :response, make_redirect_resp(struct))}
      false -> {:ok, struct}
    end
  end

  defp make_redirect_resp(struct) do
    %{
      http_status: 302,
      headers: %{
        "location" => redirect_url(struct.request),
        "x-bbc-no-scheme-rewrite" => "1",
        "cache-control" => "public, stale-while-revalidate=10, max-age=60"
      },
      body: "Redirecting"
    }
  end

  defp redirect_url(request) do
    IO.iodata_to_binary([
      to_string(request.scheme),
      "://",
      String.replace(request.host, "bbc.com", "bbc.co.uk"),
      request.path,
      Belfrage.Helpers.QueryParams.encode(request.query_params)
    ])
  end
end
