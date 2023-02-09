defmodule Belfrage.RequestTransformers.ProxyOnJoanTest do
  use ExUnit.Case, async: true

  alias Belfrage.RequestTransformers.ProxyOnJoan
  alias Belfrage.Envelope

  import Test.Support.Helper, only: [set_stack_id: 1]

  @webcore_envelope %Envelope{
    private: %Envelope.Private{
      origin: "webcore-lambda-origin"
    }
  }

  describe "call/2 when not on the joan stack" do
    setup do
      set_stack_id("bruce")
      :ok
    end

    test "the origin is not overwritten" do
      assert {:ok, @webcore_envelope} == ProxyOnJoan.call(@webcore_envelope)
    end
  end

  describe "call/2 when on the joan stack" do
    setup do
      set_stack_id("joan")
      :ok
    end

    test "the origin is overritten to be the Mozart News endpoint" do
      {:ok, envelope} = ProxyOnJoan.call(@webcore_envelope)
      assert envelope.private.origin == Application.get_env(:belfrage, :mozart_news_endpoint)
    end
  end
end
