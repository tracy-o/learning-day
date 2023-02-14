defmodule Belfrage.RequestTransformers.AppPersonalisationHalterTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  import Belfrage.Test.PersonalisationHelper

  alias Belfrage.{Envelope, Envelope.Request, Envelope.Response}
  alias Belfrage.RequestTransformers.AppPersonalisationHalter

  describe "call/2" do
    test "returns unmodified envelope when envelope.request.app? is false and personalisation enabled" do
      enable_personalisation()
      envelope = %Envelope{request: %Request{app?: false}}

      assert AppPersonalisationHalter.call(envelope) == {:ok, envelope}
    end

    test "returns unmodified envelope when envelope.request.app? is false and personalisation disabled" do
      disable_personalisation()
      envelope = %Envelope{request: %Request{app?: false}}

      assert AppPersonalisationHalter.call(envelope) == {:ok, envelope}
    end

    test "returns unmodified envelope when envelope.request.app? is true and personalisation enabled" do
      enable_personalisation()
      envelope = %Envelope{request: %Request{app?: true}}

      assert AppPersonalisationHalter.call(envelope) == {:ok, envelope}
    end

    test "returns envelope with 204 response when envelope.request.app? is true and personalisation disabled" do
      disable_personalisation()

      assert {:stop, %Envelope{request: %Request{app?: true}, response: %Response{http_status: 204}}} =
               AppPersonalisationHalter.call(%Envelope{request: %Request{app?: true}})
    end
  end
end
