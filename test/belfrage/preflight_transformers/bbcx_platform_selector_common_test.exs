defmodule Belfrage.PreflightTransformers.BBCXPlatformSelectorCommonTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.PreflightTransformers.BBCXPlatformSelectorCommon
  alias Belfrage.{Envelope, Envelope.Request}

  @mock_platform "Foo"

  test "when the cookie is present, the host is bbc.com and the country is in the allowed country list return BBCX" do
    {:ok, response} =
      BBCXPlatformSelectorCommon.add_platform_to_envelope(
        %Envelope{
          request: %Request{
            raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
            host: "www.bbc.com",
            country: "ca"
          },
          private: %Envelope.Private{production_environment: "test"}
        },
        @mock_platform
      )

    assert response.private.platform == "BBCX"
    assert response.private.bbcx_enabled == true
  end

  test "when the cookie is present, the host is bbc.com but the country is not in the allowed country list return Foo" do
    {:ok, response} =
      BBCXPlatformSelectorCommon.add_platform_to_envelope(
        %Envelope{
          request: %Request{
            host: "www.bbc.com",
            country: "gb",
            raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
          },
          private: %Envelope.Private{production_environment: "test"}
        },
        @mock_platform
      )

    assert response.private.platform == "Foo"
    assert response.private.bbcx_enabled == true
  end

  test "when the cookie is present, the host is not bbc.com and the country is in the allowed country list return Foo" do
    {:ok, response} =
      BBCXPlatformSelectorCommon.add_platform_to_envelope(
        %Envelope{
          request: %Request{
            host: "www.bbc.co.uk",
            country: "us",
            raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
          },
          private: %Envelope.Private{production_environment: "test"}
        },
        @mock_platform
      )

    assert response.private.platform == "Foo"
    assert response.private.bbcx_enabled == true
  end

  test "when the cookie is not present, the host is bbc.com and the country is in the allowed country list return Foo" do
    {:ok, response} =
      BBCXPlatformSelectorCommon.add_platform_to_envelope(
        %Envelope{
          request: %Request{
            host: "www.bbc.com",
            country: "us"
          },
          private: %Envelope.Private{production_environment: "test"}
        },
        @mock_platform
      )

    assert response.private.platform == "Foo"
    assert response.private.bbcx_enabled == true
  end

  test "when the cookie is set to '0', the host is bbc.com and the country is in the allowed country list return Foo" do
    {:ok, response} =
      BBCXPlatformSelectorCommon.add_platform_to_envelope(
        %Envelope{
          request: %Request{
            raw_headers: %{"cookie-ckns_bbccom_beta" => "0"},
            host: "www.bbc.com",
            country: "ca"
          },
          private: %Envelope.Private{production_environment: "test"}
        },
        @mock_platform
      )

    assert response.private.platform == "Foo"
    assert response.private.bbcx_enabled == true
  end

  test "when the cookie is present, the host is bbc.com, the country is in the allowed country list but the bbcx_enabled Dial is disabled return Foo" do
    stub_dials(bbcx_enabled: "false")

    {:ok, response} =
      BBCXPlatformSelectorCommon.add_platform_to_envelope(
        %Envelope{
          request: %Request{
            raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
            host: "www.bbc.com",
            country: "ca"
          },
          private: %Envelope.Private{production_environment: "test"}
        },
        @mock_platform
      )

    assert response.private.platform == "Foo"
    assert response.private.bbcx_enabled == true
  end

  test "when the cookie is present, the host is bbc.com, the country is in the allowed country list but the Cosmos environment is live return Foo and set bbcx_enabled to false" do
    {:ok, response} =
      BBCXPlatformSelectorCommon.add_platform_to_envelope(
        %Envelope{
          request: %Request{
            raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
            host: "www.bbc.com",
            country: "ca"
          },
          private: %Envelope.Private{production_environment: "live"}
        },
        @mock_platform
      )

    assert response.private.platform == "Foo"
    assert response.private.bbcx_enabled == false
  end

  test "when the Cosmos environment is live, always return Foo and set bbcx_enabled to false" do
    {:ok, response} =
      BBCXPlatformSelectorCommon.add_platform_to_envelope(
        %Envelope{
          request: %Request{
            raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
            host: "www.bbc.co.uk",
            country: "gb"
          },
          private: %Envelope.Private{production_environment: "live"}
        },
        @mock_platform
      )

    assert response.private.platform == "Foo"
    assert response.private.bbcx_enabled == false
  end
end
