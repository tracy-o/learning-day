defmodule Belfrage.PreflightTransformers.BBCXCulturePlatformSelectorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.PreflightTransformers.BBCXCulturePlatformSelector
  alias Belfrage.{Envelope, Envelope.Request}

  setup do
    stub_dials(bbcx_enabled: "true")
  end

  test "when envelope data does not fulfill bbcx selection requirements, return DotComCulture" do
    {:ok, response} =
      BBCXCulturePlatformSelector.call(%Envelope{
        request: %Request{
          host: "www.bbc.com",
          country: "gb",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "DotComCulture"
  end

  test "when envelope data does fulfill bbcx selection requirements, return BBCX" do
    {:ok, response} =
      BBCXCulturePlatformSelector.call(%Envelope{
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
