defmodule Routes.Specs.Selectors.AblSpecSelector do
  alias Belfrage.Envelope.Request

  @behaviour Belfrage.Behaviours.Selector

  @impl true
  def call(%Request{query_params: query_params}) do
    {:ok, {"AblData", get_partition(query_params)}}
  end

  defp get_partition(%{
    "clientName" => "Chrysalis",
    "service" => "news",
    "type" => "index",
    "page" => "chrysalis_discovery"
  }), do: "ChrysalisNewsHomePagePartition"

  defp get_partition(%{"service" => "news", "type" => "asset"}), do: "CPSNewsAssetPartition"
  defp get_partition(%{"service" => "news", "type" => "index"}), do: "CPSNewsIndexPartition"
  defp get_partition(%{"service" => "news", "type" => "article"}), do: "OptimoNewsAssetPartition"

  defp get_partition(%{"clientName" => "Arabic"}), do: "WSContentPartition"
  defp get_partition(%{"clientName" => "Hindi"}), do: "WSContentPartition"
  defp get_partition(%{"clientName" => "Mundo"}), do: "WSContentPartition"
  defp get_partition(%{"clientName" => "Russian"}), do: "WSContentPartition"

  defp get_partition(_), do: "CatchAllPartition"
end
