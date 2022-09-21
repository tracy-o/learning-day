defmodule Belfrage.Transformers.RssFeedDomainValidator do
  use Belfrage.Transformers.Transformer

  def call(rest, struct = %Struct{request: request = %Request{}}) do
    if struct.request.subdomain == "feeds" do
      then_do(rest, struct)
    else
      {:stop_pipeline, Struct.put_status(struct, 404)}
    end
  end
end
