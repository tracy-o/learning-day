defmodule Belfrage.RequestTransformers.RssFeedDomainValidator do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(struct) do
    if struct.request.subdomain == "feeds" do
      {:ok, struct}
    else
      {:stop, Struct.put_status(struct, 404)}
    end
  end
end
