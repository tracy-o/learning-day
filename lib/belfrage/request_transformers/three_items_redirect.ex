defmodule Belfrage.RequestTransformers.ThreeItemsRedirect do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.RequestTransformers.ThreeItemsRedirect.ThreeItemsGuids

  @impl Transformer
  def call(envelope) do
    if ThreeItemsGuids.should_redirect_item_to_clip(envelope.request.path_params["id"]) do
      redirect(envelope, "/clip/")
    else
      redirect(envelope, "/article/")
    end
  end

  defp redirect(envelope, destination) do
    {
      :stop,
      Envelope.add(envelope, :response, %{
        http_status: 301,
        headers: %{
          "location" => String.replace(envelope.request.path, "/item/", destination),
          "x-bbc-no-scheme-rewrite" => "1",
          "cache-control" => "public, stale-while-revalidate=10, max-age=60"
        },
        body: ""
      })
    }
  end
end
