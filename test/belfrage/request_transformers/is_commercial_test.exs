defmodule Belfrage.RequestTransformers.IsCommercialTest do
  use ExUnit.Case, async: true

  import Test.Support.Helper, only: [set_environment: 1]
  import Test.Support.StubHelper, only: [stub_dial: 2]

  alias Belfrage.RequestTransformers.IsCommercial
  alias Belfrage.Utils.Current

  describe "call/1" do
    test "adds a request header if request qualifies for bbcx" do
      stub_dial(:bbcx_enabled, "enabled")
      set_environment("test")

      bbcx_envelope = %Envelope{
        request: %Envelope.Request{
          cookies: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "bbc.com",
          country: "ca"
        }
      }

      {:ok, envelope} = IsCommercial.call(bbcx_envelope)

      assert envelope.request.raw_headers = %{"is_commercial" => "true"}
    end
  end
end
