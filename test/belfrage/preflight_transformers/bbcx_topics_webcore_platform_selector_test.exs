defmodule Belfrage.PreflightTransformers.BBCXTopicsWebcorePlatformSelectorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.PreflightTransformers.BBCXTopicsWebcorePlatformSelector
  alias Belfrage.{Envelope, Envelope.Request}

  setup do
    stub_dials(bbcx_enabled: "true")
  end

  test "when the request meets the criteria for BBCX and id is a Tipo ID and there is no slug param then the BBCX platform is selected" do
    {:ok, response} =
      BBCXTopicsWebcorePlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "www.bbc.com",
          country: "ca",
          path_params: %{"id" => "cg41ylwvgjyt"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "BBCX"
    assert response.private.bbcx_enabled == true
  end

  test "when the request meets the criteria for BBCX, the id is a Tipo ID and there a slug param then the Webcore platform is selected" do
    {:ok, response} =
      BBCXTopicsWebcorePlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "www.bbc.com",
          country: "ca",
          path_params: %{"id" => "cg41ylwvgjyt", "slug" => "some-slug"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "Webcore"
    assert response.private.bbcx_enabled == false
  end

  test "when the request meets the criteria for BBCX, the id is a GUID and there is no slug param then the Webcore platform is selected" do
    {:ok, response} =
      BBCXTopicsWebcorePlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "www.bbc.com",
          country: "us",
          path_params: %{"id" => "66535a45-8563-4598-be75-851e8e3cb9a9"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "Webcore"
    assert response.private.bbcx_enabled == false
  end

  test "when the request does not meet the criteria for BBCX and id is a Tipo ID and there is no slug param then the Webcore platform is selected" do
    {:ok, response} =
      BBCXTopicsWebcorePlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "0"},
          host: "www.bbc.com",
          country: "us",
          path_params: %{"id" => "cg41ylwvgjyt"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "Webcore"
    assert response.private.bbcx_enabled == true
  end

  test "when the request does not meet the criteria for BBCX and id is a GUID and there is no slug param then the Webcore platform is selected" do
    {:ok, response} =
      BBCXTopicsWebcorePlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "0"},
          host: "www.bbc.com",
          country: "us",
          path_params: %{"id" => "66535a45-8563-4598-be75-851e8e3cb9a9"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "Webcore"
    assert response.private.bbcx_enabled == false
  end

  test "when the request does not meet the criteria for BBCX and id is a Tipo ID and there is a slug param then the Webcore platform is selected" do
    {:ok, response} =
      BBCXTopicsWebcorePlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "0"},
          host: "www.bbc.com",
          country: "us",
          path_params: %{"id" => "66535a45-8563-4598-be75-851e8e3cb9a9", "slug" => "my-slug"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "Webcore"
    assert response.private.bbcx_enabled == false
  end
end
