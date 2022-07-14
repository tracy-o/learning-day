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
          "location" => location(struct.request.path_params),
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, max-age=60"
        },
        body: "Redirecting"
      })
    }
  end

  defp location(%{"page" => page, "id" => id, "service" => service, "variant" => variant}) do
    "/#{service}/#{variant}/topics/#{id}?page=#{page}"
  end

  defp location(%{"page" => page, "id" => id, "service" => service}) do
    "/#{service}/topics/#{id}?page=#{page}"
  end
end
