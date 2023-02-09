defmodule Belfrage.RequestTransformers.RssFeedDomainValidator do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope) do
    if envelope.request.subdomain == "feeds" do
      {:ok, envelope}
    else
      {:stop, Envelope.put_status(envelope, 404)}
    end
  end
end
