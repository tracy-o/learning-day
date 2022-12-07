defmodule Belfrage.RequestTransformers.ReplayedTraffic do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(struct = %Struct{request: %Struct.Request{has_been_replayed?: true}}) do
    struct =
      Struct.add(struct, :private, %{
        origin: Application.get_env(:belfrage, :origin_simulator),
        platform: OriginSimulator
      })

    {:ok, struct}
  end

  def call(struct), do: {:ok, struct}
end
