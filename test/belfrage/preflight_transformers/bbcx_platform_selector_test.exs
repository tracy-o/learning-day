defmodule Belfrage.PreflightTransformers.BBCXPlatformSelectorTest do
  use ExUnit.Case

  alias Belfrage.PreflightTransformers.BBCXPlatformSelector
  alias Belfrage.{Envelope, Envelope.Request}

  test "when the cookie is present, and the host is bbc.com but the country is not us or ca return Webcore" do
    {:ok, response} =
      BBCXPlatformSelector.call(%Envelope{
        request: %Request{
          host: "www.bbc.com",
          country: "gb",
          raw_headers: %{"cookie_ckns_bbccom_beta" => "a truthy value"}
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "Webcore"
  end

  test "when the cookie is not present, and the host is bbc.com but the country is not us or ca return Webcore" do
    {:ok, response} =
      BBCXPlatformSelector.call(%Envelope{
        request: %Request{
          host: "www.bbc.com",
          country: "gb"
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "Webcore"
  end

  test "when the cookie is not present, and the host is bbc.com and the country is us or ca return Webcore" do
    {:ok, response} =
      BBCXPlatformSelector.call(%Envelope{
        request: %Request{
          host: "www.bbc.com",
          country: "us"
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "Webcore"
  end

  test " when the cookie is present, and the host is bbc.com and the country is us or ca return BBCX" do
    {:ok, response} =
      BBCXPlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie_ckns_bbccom_beta" => "another truthy value"},
          host: "www.bbc.com",
          country: "ca"
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "BBCX"
  end

  test " when the cookie is present, and the host is bbc.com and the country is us or ca, but the Cosmos environment is live return WebCore" do
    {:ok, response} =
      BBCXPlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie_ckns_bbccom_beta" => "another truthy value"},
          host: "www.bbc.com",
          country: "ca"
        },
        private: %Envelope.Private{production_environment: "live"}
      })

    assert response.private.platform == "Webcore"
  end

  test " when the cookie is present, and the host is not bbc.com and the country is us or ca return Webcore" do
    {:ok, response} =
      BBCXPlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie_ckns_bbccom_beta" => "value"},
          host: "www.bbc.co.uk",
          country: "ca"
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "Webcore"
  end

  test " when the cookie is a non-truthy value, and the host is bbc.com and the country is us or ca return Webcore" do
    {:ok, response} =
      BBCXPlatformSelector.call(%Envelope{
        request: %Request{
          raw_headers: %{"cookie_ckns_bbccom_beta" => ""},
          host: "www.bbc.com",
          country: "ca"
        },
        private: %Envelope.Private{production_environment: "test"}
      })

    assert response.private.platform == "Webcore"
  end
end
