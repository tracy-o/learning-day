defmodule Belfrage.Transformers.NewsArticleValidatorTest do
  use ExUnit.Case

  alias Belfrage.Transformers.NewsArticleValidator
  alias Belfrage.Struct

  import Test.Support.Helper, only: [set_stack_id: 1]

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
end
