defmodule Belfrage.RequestTransformers.ElectoralCommissionPath do
  use Belfrage.Behaviours.Transformer

  @impl Transformer
  def call(envelope = %{request: %{path: path}}) do
    {:ok,
     envelope
     |> Envelope.add(:request, %{path: interpolate_path(path)})}
  end

  defp interpolate_path(<<"/election2023", path::binary>>) do
    "/api/v1/#{path}/?token=f110d812b94d8cdf517765ff8657b89e8b08ebd6"
  end
end
