defmodule Belfrage.Transformers.NewsArticleValidatorTest do
  use ExUnit.Case

  alias Belfrage.Transformers.NewsArticleValidator
  alias Belfrage.Struct

  describe "call/2 when not on the joan stack" do
    setup do
      set_stack_id("cedric")
      :ok
    end

    test "404 is returned if article id does not match" do
      assert {:stop_pipeline, %Struct{response: %Struct.Response{http_status: 404}}} =
               NewsArticleValidator.call([], %Struct{
                 request: %Struct.Request{path_params: %{"id" => "123456789123456789"}}
               })
    end

    test "404 is not returned if article id matches" do
      struct = %Struct{
        request: %Struct.Request{path_params: %{"id" => "49336144"}}
      }

      assert {:ok, ^struct} = NewsArticleValidator.call([], struct)
    end
  end

  describe "call/2 when on the joan stack" do
    setup do
      set_stack_id("joan")
      :ok
    end

    test "404 is not returned" do
      struct = %Struct{
        request: %Struct.Request{path_params: %{"id" => "123456789123456789"}}
      }

      assert {:ok, ^struct} = NewsArticleValidator.call([], struct)
    end
  end

  defp set_stack_id(stack_id) do
    prev_stack_id = Application.get_env(:belfrage, :stack_id)
    Application.put_env(:belfrage, :stack_id, stack_id)

    on_exit(fn -> Application.put_env(:belfrage, :stack_id, prev_stack_id) end)
  end
end
