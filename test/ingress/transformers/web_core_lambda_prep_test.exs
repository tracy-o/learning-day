defmodule Ingress.Transformers.WebCoreLambdaPrepTest do
  use ExUnit.Case

  alias Ingress.Transformers.WebCoreLambdaPrep, as: Subject
  alias Test.Support.StructHelper
  alias Ingress.Struct

  @original_struct StructHelper.build(
                     request: %{
                       path: "/",
                       payload: %{a_request: "for data"}
                     },
                     private: %{
                       pipeline: ["WebCoreLambdaPrep"]
                     }
                   )

  test "builds lambda payload for calling a web core lambda" do
    assert {:ok,
            %Struct{
              request: %Struct.Request{
                payload: %{
                  path: "/",
                  payload: %{a_request: "for data"}
                }
              }
            }} = Subject.call([], @original_struct)
  end
end
