defmodule Routes.Specs.Selectors.AblSpecSelectorTest do
  use ExUnit.Case

  alias Belfrage.Envelope
  alias Belfrage.Behaviours.Selector

  test "returns Abl spec with WSContentPartition" do
    assert Selector.call("AblSpecSelector", :spec, %Envelope.Request{
             path: "/fd/abl",
             query_params: %{
               "clientName" => "Hindi",
               "clientVersion" => "pre-4",
               "page" => "india-63495511",
               "release" => "public-alpha",
               "service" => "hindi",
               "type" => "asset"
             }
           }) == {:ok, {"AblData", "WSContentPartition"}}
  end

  test "returns Abl spec with CPSNewsIndexPartition" do
    assert Selector.call("AblSpecSelector", :spec, %Envelope.Request{
             path: "/fd/abl",
             query_params: %{
               "clientVersion" => "pre-4",
               "page" => "india-63495511",
               "release" => "public-alpha",
               "service" => "news",
               "type" => "index"
             }
           }) == {:ok, {"AblData", "CPSNewsIndexPartition"}}
  end

  test "returns Abl spec with CPSNewsAssetPartition" do
    assert Selector.call("AblSpecSelector", :spec, %Envelope.Request{
             path: "/fd/abl",
             query_params: %{
               "clientVersion" => "pre-4",
               "page" => "india-63495511",
               "release" => "public-alpha",
               "service" => "news",
               "type" => "asset"
             }
           }) == {:ok, {"AblData", "CPSNewsAssetPartition"}}
  end

  test "returns Abl spec with OptimoNewsAssetPartition" do
    assert Selector.call("AblSpecSelector", :spec, %Envelope.Request{
             path: "/fd/abl",
             query_params: %{
               "clientVersion" => "pre-4",
               "page" => "india-63495511",
               "release" => "public-alpha",
               "service" => "news",
               "type" => "article"
             }
           }) == {:ok, {"AblData", "OptimoNewsAssetPartition"}}
  end

  test "returns Abl spec with ChrysalisNewsHomePagePartition" do
    assert Selector.call("AblSpecSelector", :spec, %Envelope.Request{
             path: "/fd/abl",
             query_params: %{
               "clientName" => "Chrysalis",
               "clientVersion" => "pre-4",
               "page" => "chrysalis_discovery",
               "release" => "public-alpha",
               "service" => "news",
               "type" => "index"
             }
           }) == {:ok, {"AblData", "ChrysalisNewsHomePagePartition"}}
  end

  test "returns Abl spec with CatchAllPartition" do
    assert Selector.call("AblSpecSelector", :spec, %Envelope.Request{
             path: "/fd/abl",
             query_params: %{
               "clientName" => "Other",
               "clientVersion" => "pre-4",
               "page" => "india-63495511",
               "release" => "public-alpha"
             }
           }) == {:ok, {"AblData", "CatchAllPartition"}}
  end
end
