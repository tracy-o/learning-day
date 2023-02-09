defmodule Belfrage.RequestTransformers.ObitModeTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  import Belfrage.Test.StubHelper

  alias Belfrage.RequestTransformers.ObitMode
  alias Belfrage.Envelope

  @envelope %Envelope{
    request: %Envelope.Request{
      raw_headers: %{"header1" => "header1value"}
    }
  }

  describe "when the ObitMode dial is on" do
    test "obit-mode: 'on' will be set in the raw headers" do
      stub_dial(:obit_mode, "on")

      {:ok, envelope} = ObitMode.call(@envelope)
      assert envelope.request.raw_headers == %{"header1" => "header1value", "obit-mode" => "on"}
    end
  end

  describe "when the ObitMode dial is off" do
    test "obit-mode: 'off' will be set in the raw headers" do
      stub_dial(:obit_mode, "off")

      {:ok, envelope} = ObitMode.call(@envelope)
      assert envelope.request.raw_headers == %{"header1" => "header1value", "obit-mode" => "off"}
    end
  end
end
