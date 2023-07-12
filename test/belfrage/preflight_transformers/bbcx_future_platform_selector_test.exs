defmodule Belfrage.PreflightTransformers.BBCXFuturePlatformSelectorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.PreflightTransformers.BBCXFuturePlatformSelector
  alias Belfrage.{Envelope, Envelope.Request}

  setup do
    stub_dials(bbcx_enabled: "true")
  end

  test "when the envelope data does fulfill the bbcx selection requirements, return BBCX" do
    {:ok, response} =
      BBCXFuturePlatformSelector.call(%Envelope{
        request: %Request{
          host: "www.bbc.com",
          country: "us",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "BBCX"
  end

  test "when the envelope data does NOT fulfill the bbcx selection requirements, return DotComFuture" do
    {:ok, response} =
      BBCXFuturePlatformSelector.call(%Envelope{
        request: %Request{
          host: "www.bbc.com",
          country: "gb",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "DotComFuture"
  end
end