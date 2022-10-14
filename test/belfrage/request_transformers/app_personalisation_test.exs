defmodule Belfrage.RequestTransformers.AppPersonalisationTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  import Belfrage.Test.PersonalisationHelper

  alias Belfrage.{Struct, Struct.Request, Struct.Response}
  alias Belfrage.RequestTransformers.AppPersonalisation

  describe "call/2" do
    test "returns unmodified struct when struct.request.app? is false and personalisation enabled" do
      enable_personalisation()
      struct = %Struct{request: %Request{app?: false}}

      assert AppPersonalisation.call([], struct) == {:ok, struct}
    end

    test "returns unmodified struct when struct.request.app? is false and personalisation disabled" do
      disable_personalisation()
      struct = %Struct{request: %Request{app?: false}}

      assert AppPersonalisation.call([], struct) == {:ok, struct}
    end

    test "returns unmodified struct when struct.request.app? is true and personalisation enabled" do
      enable_personalisation()
      struct = %Struct{request: %Request{app?: true}}

      assert AppPersonalisation.call([], struct) == {:ok, struct}
    end

    test "returns struct with 503 response when struct.request.app? is true and personalisation disabled" do
      disable_personalisation()

      assert {:stop_pipeline, %Struct{request: %Request{app?: true}, response: %Response{http_status: 503}}} =
               AppPersonalisation.call([], %Struct{request: %Request{app?: true}})
    end
  end
end
