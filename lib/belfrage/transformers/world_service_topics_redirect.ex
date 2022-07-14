defmodule Belfrage.Transformers.WorldServiceTopicsRedirect do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(_rest, struct = %Struct{}) do
    redirect(struct)
  end

  def redirect(struct) do
    {
      :redirect,
      Struct.add(struct, :response, %{
        http_status: 301,
        headers: %{
          "location" => location(struct.request.path_params, struct.request.path),
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, max-age=60"
        },
        body: "Redirecting"
      })
    }
  end

  defp location(%{"page" => page, "id" => id}, path) do
    base_path(path) <> "/topics/#{id}?page=#{page}"
  end

  defp base_path(path) do
    String.split(path, "/topics") |> hd()
  end
end
