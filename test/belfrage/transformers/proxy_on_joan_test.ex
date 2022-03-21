defmodule Belfrage.Transformers.ProxyOnJoanTest do
  use ExUnit.Case, async: true

  alias Belfrage.Transformers.ProxyOnJoan
  alias Belfrage.Struct

  @webcore_struct %Struct{
    private: %Struct.Private{
      origin: "webcore-lambda-origin"
    }
  }

  describe "call/2 when not on the joan stack" do
    setup do
      set_stack_id("bruce")
      :ok
    end

    test "the origin is not overwritten" do
      assert {:ok, @webcore_struct} == ProxyOnJoan.call([], @webcore_struct)
    end
  end

  describe "call/2 when on the joan stack" do
    setup do
      set_stack_id("joan")
      :ok
    end

    test "the origin is overritten to be the Mozart News endpoint" do
      {:ok, struct} = ProxyOnJoan.call([], @webcore_struct)
      assert struct.private.origin == Application.get_env(:belfrage, :mozart_news_endpoint)
    end
  end

  defp set_stack_id(stack_id) do
    prev_stack_id = Application.get_env(:belfrage, :stack_id)
    Application.put_env(:belfrage, :stack_id, stack_id)

    on_exit(fn -> Application.put_env(:belfrage, :stack_id, prev_stack_id) end)
  end
end
