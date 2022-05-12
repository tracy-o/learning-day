defmodule Belfrage.Transformers.ObitModeTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  import Belfrage.Test.StubHelper

  alias Belfrage.Transformers.ObitMode
  alias Belfrage.Struct

  @struct %Struct{
    request: %Struct.Request{
      raw_headers: %{"header1" => "header1value"}
    }
  }

  describe "when the ObitMode dial is on" do
    test "obit-mode: 'on' will be set in the raw headers" do
      stub_dial(:obit_mode, "on")

      {:ok, struct} = ObitMode.call([], @struct)
      assert struct.request.raw_headers == %{"header1" => "header1value", "obit-mode" => true}
    end
  end

  describe "when the ObitMode dial is off" do
    test "obit-mode: 'off' will be set in the raw headers" do
      stub_dial(:obit_mode, "off")

      {:ok, struct} = ObitMode.call([], @struct)
      assert struct.request.raw_headers == %{"header1" => "header1value", "obit-mode" => false}
    end
  end
end
