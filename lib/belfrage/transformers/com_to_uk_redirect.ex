defmodule Belfrage.Transformers.ComToUKRedirect do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    case String.ends_with?(struct.request.host, "bbc.com") do
      true ->
        {
          :redirect,
          Struct.add(struct, :response, %{
            http_status: 302,
            headers: %{
              "location" => redirect_url(struct.request),
              "x-bbc-no-scheme-rewrite" => "1",
              "cache-control" => "public, stale-while-revalidate=10, max-age=60"
            },
            body: "Redirecting"
          })
        }

      false ->
        then(rest, struct)
    end
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
