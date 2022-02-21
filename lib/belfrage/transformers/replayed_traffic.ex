defmodule Belfrage.Transformers.ReplayedTraffic do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct = %Struct{request: %Struct.Request{has_been_replayed?: true}}) do
    then_do(rest, Struct.add(struct, :private, %{origin: Application.get_env(:belfrage, :origin_simulator)}))
  end

  @impl true
  def call(rest, struct), do: then_do(rest, struct)
end
