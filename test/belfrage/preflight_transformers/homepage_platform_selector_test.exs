defmodule Belfrage.PreflightTransformers.HomepagePlatformSelectorCommonTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.PreflightTransformers.HomepagePlatformSelector
  alias Belfrage.{Envelope, Envelope.Request}

  setup do
    stub_dials(bbcx_enabled: "true")
  end

  test "when the host is bbc.com and the request does not meet the criteria for BBCX then the DotCom platform is used" do
    {:ok, response} =
      HomepagePlatformSelector.call(%Envelope{
        request: %Request{
          host: "www.bbc.com",
          country: "gb",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
        }
      })

    assert response.private.platform == "DotComHomepage"
  end

  test "when the host is bbc.com and the request meets the criteria for BBCX then the BBCX platform is used" do
    {:ok, response} =
      HomepagePlatformSelector.call(%Envelope{
        request: %Request{
          host: "www.bbc.com",
          country: "us",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "BBCX"
  end

  test "when the host is bbc.com and the request meets the criteria for BBCX on the live env. then the DotCom platform is used" do
    {:ok, response} =
      HomepagePlatformSelector.call(%Envelope{
        request: %Request{
          host: "www.bbc.com",
          country: "us",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
        },
        private: %Envelope.Private{production_environment: "live"}
      })

    assert response.private.platform == "DotComHomepage"
  end

  test "when the host is bbc.co.uk then Webcore is used" do
    {:ok, response} =
      HomepagePlatformSelector.call(%Envelope{
        request: %Request{
          host: "www.bbc.co.uk",
          country: "us",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
        }
      })

    assert response.private.platform == "Webcore"
  end

  test "when the host is belfrage then Webcore is used" do
    {:ok, response} =
      HomepagePlatformSelector.call(%Envelope{
        request: %Request{
          host: "www.belfrage.api.bbc.co.uk",
          country: "us",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
        }
      })

    assert response.private.platform == "Webcore"
  end

  test "when the host is localhost then Webcore is used" do
    {:ok, response} =
      HomepagePlatformSelector.call(%Envelope{
        request: %Request{
          host: "localhost",
          country: "us",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
        }
      })

    assert response.private.platform == "Webcore"
  end

  test "when the host is empty then Webcore is used" do
    {:ok, response} =
      HomepagePlatformSelector.call(%Envelope{
        request: %Request{
          host: "",
          country: "us",
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"}
        }
      })

    assert response.private.platform == "Webcore"
  end
end
