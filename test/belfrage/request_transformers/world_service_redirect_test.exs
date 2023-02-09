defmodule Belfrage.RequestTransformers.WorldServiceRedirectTest do
  use ExUnit.Case

  alias Belfrage.RequestTransformers.WorldServiceRedirect
  alias Belfrage.Envelope

  describe "http requests" do
    @http_uk_request_envelope %Envelope{
      private: %Envelope.Private{origin: "http://www.bbc.co.uk"},
      request: %Envelope.Request{
        scheme: :http,
        host: "www.bbc.co.uk",
        path: "/_web_core"
      }
    }

    test ".co.uk will be uplifted to https and redirected to .com" do
      assert {
               :stop,
               %Belfrage.Envelope{
                 response: %Belfrage.Envelope.Response{
                   http_status: 302,
                   body: "Redirecting",
                   headers: %{
                     "location" => "https://www.bbc.com/_web_core",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                   }
                 }
               }
             } = WorldServiceRedirect.call(@http_uk_request_envelope)
    end

    @http_uk_with_qs_request_envelope %Envelope{
      private: %Envelope.Private{origin: "https://www.bbc.co.uk"},
      request: %Envelope.Request{
        host: "www.bbc.co.uk",
        path: "/_web_core",
        query_params: %{
          "override" => "true"
        },
        scheme: :http
      }
    }

    test ".co.uk with a query string will be uplifted to https and redirected to .com with the query string remains" do
      assert {
               :stop,
               %Belfrage.Envelope{
                 response: %Belfrage.Envelope.Response{
                   http_status: 302,
                   body: "Redirecting",
                   headers: %{
                     "location" => "https://www.bbc.com/_web_core?override=true",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                   }
                 }
               }
             } = WorldServiceRedirect.call(@http_uk_with_qs_request_envelope)
    end

    @http_com_request_envelope %Envelope{
      private: %Envelope.Private{origin: "http://www.bbc.com"},
      request: %Envelope.Request{
        host: "www.bbc.com",
        path: "/_web_core",
        scheme: :http
      }
    }

    test ".com will be uplifted to https" do
      assert {
               :stop,
               %Belfrage.Envelope{
                 response: %Belfrage.Envelope.Response{
                   http_status: 302,
                   body: "Redirecting",
                   headers: %{
                     "location" => "https://www.bbc.com/_web_core",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                   }
                 }
               }
             } = WorldServiceRedirect.call(@http_com_request_envelope)
    end

    @http_com_with_qs_request_envelope %Envelope{
      private: %Envelope.Private{origin: "https://www.bbc.com"},
      request: %Envelope.Request{
        host: "www.bbc.com",
        path: "/_web_core",
        query_params: %{
          "override" => "true"
        },
        scheme: :http
      }
    }

    test ".com request with qs will be uplifted to https and redirected to .com and the query string remain" do
      assert {
               :stop,
               %Belfrage.Envelope{
                 response: %Belfrage.Envelope.Response{
                   http_status: 302,
                   body: "Redirecting",
                   headers: %{
                     "location" => "https://www.bbc.com/_web_core?override=true",
                     "x-bbc-no-scheme-rewrite" => "1",
                     "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                   }
                 }
               }
             } = WorldServiceRedirect.call(@http_com_with_qs_request_envelope)
    end
  end

  describe "https requests" do
    @https_com_request_envelope %Envelope{
      private: %Envelope.Private{origin: "https://www.bbc.com"},
      request: %Envelope.Request{
        host: "www.bbc.com",
        path: "/_web_core",
        scheme: :https
      }
    }

    test ".com request will not redirect" do
      assert {:ok, @https_com_request_envelope} = WorldServiceRedirect.call(@https_com_request_envelope)
    end

    @https_com_with_qs_request_envelope %Envelope{
      private: %Envelope.Private{origin: "https://www.bbc.com"},
      request: %Envelope.Request{
        host: "www.bbc.com",
        path: "/_web_core",
        query_params: %{
          "override" => "true"
        },
        scheme: :https
      }
    }

    test ".com request with a query string will not redirect" do
      assert {:ok, @https_com_with_qs_request_envelope} = WorldServiceRedirect.call(@https_com_with_qs_request_envelope)
    end
  end

  @https_api_request_envelope %Envelope{
    private: %Envelope.Private{origin: "https://bruce.belfrage.api.bbc.co.uk"},
    request: %Envelope.Request{
      host: "bruce.belfrage.api.bbc.co.uk",
      path: "/_web_core",
      query_params: %{
        "override" => "true"
      },
      scheme: :https
    }
  }

  test ".api hosts will not be redirected" do
    assert {:ok, @https_api_request_envelope} = WorldServiceRedirect.call(@https_api_request_envelope)
  end
end
