defmodule Ingress.Transformers.ReplayedTrafficTransformer do
  use Ingress.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{has_been_replayed?: true}}) do
    struct = Struct.add(struct, :private, %{origin: Application.get_env(:ingress, :origin)})

    then(rest, struct)
  end

  @impl true
  def call(rest, struct) do
    then(rest, struct)
  end
end
