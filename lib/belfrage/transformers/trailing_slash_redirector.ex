defmodule Belfrage.Transformers.TrailingSlashRedirector do
  alias Belfrage.Struct
  alias Belfrage.Helpers.QueryParams
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{}) do
    if trailing_slash?(struct.request.path) do
      redirect(struct)
    else
      then(rest, struct)
    end
  end

  defp redirect(struct) do
    {
      :redirect,
      Struct.add(struct, :response, %{
        http_status: 301,
        headers: %{
          "location" => relative_url(struct.request),
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, max-age=60"
        }
      })
    }
  end

  defp relative_url(%Struct.Request{path: path, query_params: query_params}) do
    remove_trailing(path) <> QueryParams.encode(query_params)
  end

  defp remove_trailing(path) do
    String.replace_trailing(path, "/", "")
    |> case do
      "" -> "/"
      path -> path
    end
  end

  defp trailing_slash?(path) do
    path != "/" and String.ends_with?(path, "/")
  end
end
