defmodule Belfrage.RequestTransformers.RssFeedDomainValidator do
  use Belfrage.Transformer

  def call(rest, struct) do
    if struct.request.subdomain == "feeds" do
      then_do(rest, struct)
    else
      {:stop_pipeline, Struct.put_status(struct, 404)}
    end
  end
end
