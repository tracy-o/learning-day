defmodule Belfrage.Transformers.BBCOriginHeader do
  use Belfrage.Transformers.Transformer

  alias Belfrage.Struct
  alias Belfrage.Struct.Private

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{scheme: scheme, host: host}}) do
    request = Map.put(request, :bbc-origin, Enum.join(scheme, host, "://"))

    then_do(rest, struct)
  end
end