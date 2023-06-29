defmodule Belfrage.PreflightTransformers.BBCXFuturePlatformSelectorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.PreflightTransformers.BBCXFuturePlatformSelector
  alias Belfrage.{Envelope, Envelope.Request}

  test "when the cookie is present, and the host is bbc.com but the country is not us or ca return DotComFuture" do
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
    assert response.private.bbcx_enabled == true
  end

  test "when the cookie is not present, and the host is bbc.com but the country is not us or ca return DotComFuture" do
    {:ok, response} =
      BBCXFuturePlatformSelector.call(%Envelope{
        request: %Request{
          host: "www.bbc.com",
          country: "gb"
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "DotComFuture"
    assert response.private.bbcx_enabled == true
  end

  test "when the cookie is not present, and the host is bbc.com and the country is us or ca return DotComFuture" do
    {:ok, response} =
      BBCXFuturePlatformSelector.call(%Envelope{
        request: %Request{
          host: "www.bbc.com",
          country: "us"
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "DotComFuture"
    assert response.private.bbcx_enabled == true
  end

  test "when the cookie is present, and the host is bbc.com and the country is us or ca return BBCX" do
    {:ok, response} =
      BBCXFuturePlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "www.bbc.com",
          country: "ca"
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "BBCX"
    assert response.private.bbcx_enabled == true
  end

  test "when the cookie is present, and the host is bbc.com and the country is us or ca, but the Cosmos environment is live return WebCore" do
    {:ok, response} =
      BBCXFuturePlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "www.bbc.com",
          country: "ca"
        },
        private: %Envelope.Private{production_environment: "live"}
      })

    assert response.private.platform == "DotComFuture"
    assert response.private.bbcx_enabled == false
  end

  test "when the Cosmos environment is live always return webcore and set bbcx_enbled to false" do
    {:ok, response} =
      BBCXFuturePlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "www.bbc.co.uk",
          country: "gb"
        },
        private: %Envelope.Private{production_environment: "live"}
      })

    assert response.private.platform == "DotComFuture"
    assert response.private.bbcx_enabled == false
  end

  test "when the cookie is present, and the host is bbc.com and the country is us or ca, the Cosmos environment is test but the Dial is disabled return DotComFuture" do
    stub_dials(bbcx_enabled: "false")

    {:ok, response} =
      BBCXFuturePlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "www.bbc.com",
          country: "ca"
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "DotComFuture"
    assert response.private.bbcx_enabled == true
  end

  test "when the cookie is present, and the host is not bbc.com and the country is us or ca return DotComFuture" do
    {:ok, response} =
      BBCXFuturePlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "value"},
          host: "www.bbc.co.uk",
          country: "ca"
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "DotComFuture"
    assert response.private.bbcx_enabled == true
  end

  test "when the cookie is set to '0', and the host is bbc.com and the country is us or ca return DotComFuture" do
    {:ok, response} =
      BBCXFuturePlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "0"},
          host: "www.bbc.com",
          country: "ca"
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "DotComFuture"
    assert response.private.bbcx_enabled == true
  end
end
