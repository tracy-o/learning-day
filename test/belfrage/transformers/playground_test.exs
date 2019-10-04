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

  describe "when playground lambda function arns are not set" do
    setup do
      saved_api = Application.get_env(:belfrage, :playground_api_lambda_function)
      saved_pwa = Application.get_env(:belfrage, :playground_pwa_lambda_function)

      Application.put_env(:belfrage, :playground_api_lambda_function, nil)
      Application.put_env(:belfrage, :playground_pwa_lambda_function, nil)

      on_exit(fn ->
        Application.put_env(:belfrage, :playground_api_lambda_function, saved_api)
        Application.put_env(:belfrage, :playground_pwa_lambda_function, saved_pwa)
      end)

      :ok
    end

    test "the request continues to the original origin" do
      assert {
               :ok,
               %Belfrage.Struct{
                 private: %Belfrage.Struct.Private{
                   origin: "an-origin-set-by-the-loop"
                 }
               }
             } = PlaygroundLambda.call([], @playground_request_struct)
    end

    test "ContainerData request continues to the original origin" do
      struct = Struct.add(@playground_request_struct, :private, %{loop_id: "ContainerData"})

      assert {
               :ok,
               %Belfrage.Struct{
                 private: %Belfrage.Struct.Private{
                   origin: "an-origin-set-by-the-loop"
                 }
               }
             } = PlaygroundLambda.call([], struct)
    end
  end
end
