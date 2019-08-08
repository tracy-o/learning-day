defmodule Belfrage.Transformers.ReplayedTrafficTransformer do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{has_been_replayed?: true}}) do
    struct = Struct.add(struct, :private, %{origin: Application.get_env(:belfrage, :origin_simulator)})

    then(rest, struct)
  end

  @impl true
  def call(rest, struct) do
    then(rest, struct)
  end
end
