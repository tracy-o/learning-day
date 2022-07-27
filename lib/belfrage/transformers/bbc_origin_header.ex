defmodule Belfrage.Transformers.BBCOriginHeader do
  use Belfrage.Transformers.Transformer

  alias Belfrage.Struct
  alias Belfrage.Struct.Private

  @impl true
  def call(rest, struct) do
    struct.response.headers = Map.put(struct.response.headers, :bbc-origin, Enum.join([request.scheme, request.host], "://"))

    then_do(rest, struct)
  end
end