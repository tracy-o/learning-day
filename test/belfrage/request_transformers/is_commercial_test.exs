defmodule Belfrage.RequestTransformers.IsCommercialTest do
  use ExUnit.Case, async: true

  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.IsCommercial
  alias Belfrage.Envelope

  describe "call/1" do
    test "adds a request header if request qualifies for bbcx" do
      stub_dial(:bbcx_enabled, "true")

      bbcx_envelope = %Envelope{
        request: %Envelope.Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "bbc.com",
          country: "ca"
        },
        private: %Envelope.Private{production_environment: "test"}
      }

      {:ok, envelope} = IsCommercial.call(bbcx_envelope)

      assert envelope.request.raw_headers == %{"is_commercial" => "true"}
    end

    test "does not add is_commercial header" do
      stub_dial(:bbcx_enabled, "true")

      bbcx_envelope = %Envelope{
        request: %Envelope.Request{
          cookies: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "bbc.co.uk",
          country: "ca"
        },
        private: %Envelope.Private{production_environment: "test"}
      }

      {:ok, envelope} = IsCommercial.call(bbcx_envelope)

      refute envelope.request.raw_headers == %{"is_commercial" => "true"}
    end
  end
end
