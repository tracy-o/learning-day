defmodule Belfrage.Transformers.PlaygroundLambdaTest do
  use ExUnit.Case

  alias Belfrage.Transformers.PlaygroundLambda
  alias Test.Support.StructHelper
  alias Belfrage.Struct

  @playground_request_struct StructHelper.build(
                               request: %{playground?: true},
                               private: %{
                                 origin: "an-origin-set-by-the-loop",
                                 pipeline: ["Playground"]
                               }
                             )

  @non_playground_request_struct Struct.add(@playground_request_struct, :request, %{
                                   playground?: nil
                                 })

  test "non-playground traffic will be unaffected" do
    assert {
             :ok,
             %Struct{
               private: %Struct.Private{
                 origin: "an-origin-set-by-the-loop"
               }
             }
           } = PlaygroundLambda.call([], @non_playground_request_struct)
  end

  test "playground PWA lambda traffic will be sent to the playground PWA lambda" do
    assert {
             :ok,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 origin: "playground-pwa-lambda-function"
               }
             }
           } = PlaygroundLambda.call([], @playground_request_struct)
  end

  test "playground API lambda traffic will be sent to the playground API lambda" do
    struct = Struct.add(@playground_request_struct, :private, %{loop_id: "ContainerData"})

    assert {
             :ok,
             %Belfrage.Struct{
               private: %Belfrage.Struct.Private{
                 origin: "playground-api-lambda-function"
               }
             }
           } = PlaygroundLambda.call([], struct)
  end
end
