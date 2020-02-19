defmodule Belfrage.Transformers.SportPalTest do
  use ExUnit.Case

  alias Belfrage.Transformers.SportPal
  alias Belfrage.Struct

  @pal_request_with_qs %Struct{
    request: %Struct.Request{
      path: "/_web_core/pal",
      query_params: %{
        "show-service-calls" => "true"
      }
    },
    private: %Struct.Private{
      origin: "www.bbc.co.uk"
    }
  }

  @pal_request_without_qs %Struct{
    request: %Struct.Request{path: "/_web_core/pal"},
    private: %Struct.Private{
      origin: "www.bbc.co.uk"
    }
  }

  @no_pal_request_with_qs %Struct{
    request: %Struct.Request{
      path: "/_web_core?show-service-calls=true",
      query_params: %{
        "show-service-calls" => "true"
      }
    },
    private: %Struct.Private{
      origin: "www.bbc.co.uk"
    }
  }

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

  describe "with a query string and /pal in the url" do
    test "/pal is removed from the url and the query string remains" do
      assert {
               :ok,
               %Struct{
                 private: %Struct.Private{
                   origin: "www.bbc.co.uk"
                 },
                 request: %Struct.Request{
                   path: "/_web_core"
                 }
               }
             } = SportPal.call([], @pal_request_with_qs)
    end
  end

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
             } = SportPal.call([], @pal_request_without_qs)
    end
  end

  describe "a request is made with a query string" do
    test "the path remains the same" do
      assert {
               :ok,
               %Struct{
                 private: %Struct.Private{
                   origin: "www.bbc.co.uk"
                 },
                 request: %Struct.Request{path: "/_web_core?show-service-calls=true"}
               }
             } = SportPal.call([], @no_pal_request_with_qs)
    end
  end

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
