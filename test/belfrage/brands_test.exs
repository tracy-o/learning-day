defmodule Belfrage.BrandsTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Envelope

  describe "is_bbcx?/1" do
    test "returns true if request qualifies for bbcx content, country is ca" do
      stub_dial(:bbcx_enabled, "true")

      bbcx_envelope = %Envelope{
        request: %Envelope.Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "bbc.com",
          country: "ca"
        },
        private: %Envelope.Private{
          production_environment: "test"
        }
      }

      assert Belfrage.Brands.is_bbcx?(bbcx_envelope)
    end

    test "returns true if request qualifies for bbcx content, country is us" do
      stub_dial(:bbcx_enabled, "true")

      bbcx_envelope = %Envelope{
        request: %Envelope.Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "bbc.com",
          country: "us"
        },
        private: %Envelope.Private{
          production_environment: "test"
        }
      }

      assert Belfrage.Brands.is_bbcx?(bbcx_envelope)
    end

    test "returns true if request qualifies for bbcx content, country is gu" do
      stub_dial(:bbcx_enabled, "true")

      bbcx_envelope = %Envelope{
        request: %Envelope.Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "bbc.com",
          country: "gu"
        },
        private: %Envelope.Private{
          production_environment: "test"
        }
      }

      assert Belfrage.Brands.is_bbcx?(bbcx_envelope)
    end

    test "returns false if country code is not in allowed list of country codes" do
      stub_dial(:bbcx_enabled, "true")

      bbcx_envelope = %Envelope{
        request: %Envelope.Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "bbc.com",
          country: "gb"
        },
        private: %Envelope.Private{
          production_environment: "test"
        }
      }

      refute Belfrage.Brands.is_bbcx?(bbcx_envelope)
    end

    test "returns false if dial is turned off" do
      stub_dial(:bbcx_enabled, "false")

      bbcx_envelope = %Envelope{
        request: %Envelope.Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "bbc.com",
          country: "ca"
        },
        private: %Envelope.Private{
          production_environment: "test"
        }
      }

      refute Belfrage.Brands.is_bbcx?(bbcx_envelope)
    end

    test "returns false if environment is not test" do
      stub_dial(:bbcx_enabled, "true")

      bbcx_envelope = %Envelope{
        request: %Envelope.Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "bbc.com",
          country: "ca"
        },
        private: %Envelope.Private{
          production_environment: "live"
        }
      }

      refute Belfrage.Brands.is_bbcx?(bbcx_envelope)
    end

    test "returns false if cookie not set" do
      stub_dial(:bbcx_enabled, "true")

      bbcx_envelope = %Envelope{
        request: %Envelope.Request{
          raw_headers: %{},
          host: "bbc.com",
          country: "ca"
        },
        private: %Envelope.Private{
          production_environment: "test"
        }
      }

      refute Belfrage.Brands.is_bbcx?(bbcx_envelope)
    end

    test "returns false if cookie not set to 1" do
      stub_dial(:bbcx_enabled, "true")

      bbcx_envelope = %Envelope{
        request: %Envelope.Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "0"},
          host: "bbc.com",
          country: "ca"
        },
        private: %Envelope.Private{
          production_environment: "test"
        }
      }

      refute Belfrage.Brands.is_bbcx?(bbcx_envelope)
    end

    test "returns false if host is not bbc.com" do
      stub_dial(:bbcx_enabled, "true")

      bbcx_envelope = %Envelope{
        request: %Envelope.Request{
          raw_headers: %{"cookie-ckns_bbccom_beta" => "1"},
          host: "bbcmews.co.uk",
          country: "ca"
        },
        private: %Envelope.Private{
          production_environment: "test"
        }
      }

      refute Belfrage.Brands.is_bbcx?(bbcx_envelope)
    end
  end
end
