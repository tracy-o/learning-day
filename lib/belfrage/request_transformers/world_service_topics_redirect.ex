defmodule Belfrage.RequestTransformers.WorldServiceTopicsRedirect do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(struct = %Struct{}) do
    redirect(struct)
  end

  def redirect(struct) do
    {
      :stop,
      Struct.add(struct, :response, %{
        http_status: 302,
        headers: %{
          "location" => location(struct.request),
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, max-age=60"
        },
        body: "Redirecting"
      })
    }
  end

  defp location(%Struct.Request{path: path, path_params: %{"id" => id}}) do
    base_path(path) <> "/topics/#{id}"
  end

  defp base_path(path) do
    String.split(path, "/topics") |> hd()
  end
end
