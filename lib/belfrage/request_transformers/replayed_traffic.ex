defmodule Belfrage.RequestTransformers.ReplayedTraffic do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope = %Envelope{request: %Envelope.Request{has_been_replayed?: true}}) do
    envelope =
      Envelope.add(envelope, :private, %{
        origin: Application.get_env(:belfrage, :origin_simulator),
        platform: "OriginSimulator"
      })

    {:ok, envelope}
  end

  def call(envelope), do: {:ok, envelope}
end
