defmodule Belfrage.Transformers.PreviewLambdaTest do
  use ExUnit.Case

  alias Belfrage.Transformers.PreviewLambda
  alias Test.Support.StructHelper
  alias Belfrage.Struct

  @non_container_data_struct StructHelper.build(private: %{loop_id: "WebCore"})

  @container_data_struct Struct.add(@non_container_data_struct, :private, %{loop_id: "ContainerData"})

  test "when request is for a non ContainerData route" do
    assert {:ok, %Struct{private: %Struct.Private{origin: "preview-pwa-lambda-function"}}} =
             PreviewLambda.call([], @non_container_data_struct)
  end

  test "when request is for a ContainerData route" do
    assert {:ok, %Struct{private: %Struct.Private{origin: "preview-api-lambda-function"}}} =
             PreviewLambda.call([], @container_data_struct)
  end
end
