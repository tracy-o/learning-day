defmodule Belfrage.Transformers.SportPalTest do
  use ExUnit.Case

  alias Belfrage.Transformers.SportPal
  alias Belfrage.Struct

  @slash_pal_request %Struct{
    request: %Struct.Request{path: "/_web_core/pal"},
    private: %Struct.Private{
      origin: "www.bbc.co.uk"
    }
  }

  describe "a request is made without a query string but with /pal in the url" do
    test "/pal is removed from the url" do
      assert {
               :ok,
               %Struct{
                 private: %Struct.Private{
                   origin: "www.bbc.co.uk"
                 },
                 request: %Struct.Request{path: "/_web_core"}
               }
             } = SportPal.call([], @slash_pal_request)
    end
  end

  @slash_pal_app_request %Struct{
    request: %Struct.Request{path: "/_web_core/pal.app"},
    private: %Struct.Private{
      origin: "www.bbc.co.uk"
    }
  }

  describe "a request is made without a query string but with /pal.app in the url" do
    test "/pal is removed from the url" do
      assert {
               :ok,
               %Struct{
                 private: %Struct.Private{
                   origin: "www.bbc.co.uk"
                 },
                 request: %Struct.Request{path: "/_web_core.app"}
               }
             } = SportPal.call([], @slash_pal_app_request)
    end
  end

  @no_pal_request %Struct{
    request: %Struct.Request{
      path: "/_web_core",
      query_params: %{
        "show-service-calls" => "true"
      }
    },
    private: %Struct.Private{
      origin: "www.bbc.co.uk"
    }
  }

  describe "a request is made for a url without /pal" do
    test "the path remains the same" do
      assert {
               :ok,
               %Struct{
                 private: %Struct.Private{
                   origin: "www.bbc.co.uk"
                 },
                 request: %Struct.Request{path: "/_web_core"}
               }
             } = SportPal.call([], @no_pal_request)
    end
  end
end
