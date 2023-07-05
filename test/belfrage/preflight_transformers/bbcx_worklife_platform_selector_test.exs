defmodule Belfrage.PreflightTransformers.BBCXWorklifePlatformSelectorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.PreflightTransformers.BBCXWorklifePlatformSelector
  alias Belfrage.{Envelope, Envelope.Request}

  test "when the envelope data does not fulfill bbcx selection requirements, return DotComWorklife" do
    {:ok, response} =
      BBCXTravelPlatformSelector.call(%Envelope{
        request: %Request{
          host: "www.bbc.com",
          country: "jp",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "DotComTravel"
  end

  test "when the envelope data does fulfill bbcx selection requirements, return BBCX" do
    {:ok, response} =
      BBCXTravelPlatformSelector.call(%Envelope{
        request: %Request{
          host: "www.bbc.com",
          country: "us",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "BBCX"
  end
end
