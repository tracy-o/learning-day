defmodule Belfrage.PreFlightTransformers.AblDataPartitionSelectorTest do
  use ExUnit.Case

  alias Belfrage.PreFlightTransformers.AblDataPartitionSelector
  alias Belfrage.Envelope

  test "returns Abl spec with WSContentPartition" do
    assert_result(
      %{
        "clientName" => "Hindi",
        "clientVersion" => "pre-4",
        "page" => "india-63495511",
        "service" => "hindi",
        "type" => "asset"
      },
      "WSContentPartition"
    )
  end

  test "returns Abl spec with CPSNewsIndexPartition" do
    assert_result(
      %{
        "clientVersion" => "pre-4",
        "page" => "india-63495511",
        "service" => "news",
        "type" => "index"
      },
      "CPSNewsIndexPartition"
    )
  end

  test "returns Abl spec with CPSNewsAssetPartition" do
    assert_result(
      %{
        "clientVersion" => "pre-4",
        "page" => "india-63495511",
        "service" => "news",
        "type" => "asset"
      },
      "CPSNewsAssetPartition"
    )
  end

  test "returns Abl spec with OptimoNewsAssetPartition" do
    assert_result(
      %{
        "clientVersion" => "pre-4",
        "page" => "india-63495511",
        "service" => "news",
        "type" => "article"
      },
      "OptimoNewsAssetPartition"
    )
  end

  test "returns Abl spec with ChrysalisNewsHomePagePartition" do
    assert_result(
      %{
        "clientName" => "Chrysalis",
        "clientVersion" => "pre-4",
        "page" => "chrysalis_discovery",
        "service" => "news",
        "type" => "index"
      },
      "ChrysalisNewsHomePagePartition"
    )
  end

  test "returns Abl spec with CatchAllPartition" do
    assert_result(
      %{
        "clientName" => "Other",
        "clientVersion" => "pre-4",
        "page" => "india-63495511"
      },
      "CatchAllPartition"
    )
  end

  defp assert_result(query_params, expected_partition) do
    request = %Envelope.Request{query_params: query_params}

    assert AblDataPartitionSelector.call(%Envelope{request: request}) ==
             {:ok,
              %Envelope{
                request: %Envelope.Request{query_params: query_params},
                private: %Envelope.Private{
                  platform: "Fabl",
                  partition: expected_partition
                }
              }}
  end
end
