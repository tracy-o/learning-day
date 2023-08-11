defmodule Belfrage.PreflightTransformers.BBCXCPSPlatformSelectorTest do
  use ExUnit.Case

  use Test.Support.Helper, :mox

  alias Belfrage.PreflightTransformers.BBCXCPSPlatformSelector
  alias Belfrage.{Envelope, Envelope.Request}

  setup do
    stub_dials(bbcx_enabled: "true")
  end

  test "when the request can be BBCX and the last part of the id is over 62729301" do
    {:ok, response} =
      BBCXCPSPlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "www.bbc.com",
          country: "ca",
          path_params: %{"id" => "uk-foo-62729302"}
        },
        private: %Envelope.Private{
          production_environment: "test",
          platform: "Webcore"
        }
      })

    assert response.private.platform == "BBCX"
    assert response.private.bbcx_enabled == true
  end

  test "when the request can be BBCX and the last part of the id is below 62729302" do
    {:ok, response} =
      BBCXCPSPlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "www.bbc.com",
          country: "ca",
          path_params: %{"id" => "uk-foo-123456"}
        },
        private: %Envelope.Private{
          production_environment: "test",
          platform: "Webcore"
        }
      })

    assert response.private.platform == "Webcore"
    assert response.private.bbcx_enabled == true
  end

  test "when the request can be BBCX and the last part of the id does not end with a number" do
    {:ok, response} =
      BBCXCPSPlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "www.bbc.com",
          country: "ca",
          path_params: %{"id" => "uk-foo-not-a-number"}
        },
        private: %Envelope.Private{
          production_environment: "test",
          platform: "Webcore"
        }
      })

    assert response.private.platform == "Webcore"
    assert response.private.bbcx_enabled == true
  end

  test "when the request can be BBCX and the last part of the id only contains a number" do
    {:ok, response} =
      BBCXCPSPlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "www.bbc.com",
          country: "ca",
          path_params: %{"id" => "62729302"}
        },
        private: %Envelope.Private{
          production_environment: "test",
          platform: "Webcore"
        }
      })

    assert response.private.platform == "BBCX"
    assert response.private.bbcx_enabled == true
  end

  test "when the params do not have an id" do
    {:ok, response} =
      BBCXCPSPlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "www.bbc.com",
          country: "ca",
          path_params: %{"foo" => "uk-foo-123"}
        },
        private: %Envelope.Private{
          production_environment: "test",
          platform: "Webcore"
        }
      })

    assert response.private.platform == "Webcore"
    assert response.private.bbcx_enabled == true
  end

  test "when the id is valid but the request should not served by BBCX" do
    {:ok, response} =
      BBCXCPSPlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "0"},
          host: "www.bbc.com",
          country: "ie",
          path_params: %{"id" => "uk-foo-6272930"}
        },
        private: %Envelope.Private{
          production_environment: "test",
          platform: "Webcore"
        }
      })

    assert response.private.platform == "Webcore"
    assert response.private.bbcx_enabled == true
  end
end
