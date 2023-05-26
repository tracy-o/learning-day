defmodule Belfrage.PreflightTransformers.AblDataPartitionSelector do
  use Belfrage.Behaviours.Transformer
  alias Belfrage.Envelope

  @impl Transformer
  def call(envelope = %Envelope{request: request}) do
    {:ok,
     Envelope.add(envelope, :private, %{
       platform: "Fabl",
       partition: get_partition(request.query_params)
     })}
  end

  defp get_partition(%{
         "clientName" => "Chrysalis",
         "service" => "news",
         "type" => "index",
         "page" => "chrysalis_discovery"
       }),
       do: "ChrysalisNewsHomePagePartition"

  defp get_partition(%{"service" => "news", "type" => "asset"}), do: "CPSNewsAssetPartition"
  defp get_partition(%{"service" => "news", "type" => "index"}), do: "CPSNewsIndexPartition"
  defp get_partition(%{"service" => "news", "type" => "article"}), do: "OptimoNewsAssetPartition"

  defp get_partition(%{"clientName" => "Arabic"}), do: "WSContentPartition"
  defp get_partition(%{"clientName" => "Hindi"}), do: "WSContentPartition"
  defp get_partition(%{"clientName" => "Mundo"}), do: "WSContentPartition"
  defp get_partition(%{"clientName" => "Russian"}), do: "WSContentPartition"

  defp get_partition(_), do: "CatchAllPartition"
end
