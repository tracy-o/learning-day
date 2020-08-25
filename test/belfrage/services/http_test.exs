defmodule Belfrage.Services.HTTPTest do
  alias Belfrage.Clients
  alias Belfrage.Services.HTTP
  alias Belfrage.Struct

  use ExUnit.Case
  use Test.Support.Helper, :mox

  @get_struct %Struct{
    private: %Struct.Private{
      origin: "https://www.bbc.co.uk"
    },
    request: %Struct.Request{
      method: "GET",
      path: "/_web_core",
      country: "gb",
      host: "www.bbc.co.uk",
      query_params: %{
        "foo" => "bar"
      },
      req_svc_chain: "BELFRAGE"
    }
  }

  @post_struct %Struct{
    private: %Struct.Private{
      origin: "https://www.bbc.co.uk"
    },
    request: %Struct.Request{
      payload: ~s({"some": "data"}),
      path: "/_web_core",
      method: "POST",
      country: "gb",
      query_params: %{
        "foo" => "bar"
      }
    }
  }

  @ok_response {
    :ok,
    %Belfrage.Clients.HTTP.Response{
      status_code: 200,
      headers: %{"content-type" => "application/json"},
      body: ~s({"some": "body"})
    }
  }

  describe "HTTP service" do
    test "get returns a response" do
      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Belfrage.Clients.HTTP.Request{
             method: :get,
             url: "https://www.bbc.co.uk/_web_core?foo=bar",
             payload: "",
             headers: %{
               "accept-encoding" => "gzip",
               "x-country" => "gb",
               "user-agent" => "Belfrage",
               "x-forwarded-host" => "www.bbc.co.uk",
               "req-svc-chain" => "BELFRAGE"
             }
           } ->
          @ok_response
        end
      )

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = HTTP.dispatch(@get_struct)
    end

    test "post returns a response" do
      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Belfrage.Clients.HTTP.Request{
             method: :post,
             url: "https://www.bbc.co.uk/_web_core?foo=bar",
             payload: ~s({"some": "data"}),
             headers: %{"accept-encoding" => "gzip", "x-country" => "gb", "user-agent" => "Belfrage"}
           } ->
          @ok_response
        end
      )

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = HTTP.dispatch(@post_struct)
    end

    test "origin returns a 500 response" do
      Clients.HTTPMock
      |> expect(:execute, fn %Belfrage.Clients.HTTP.Request{
                               method: :get,
                               url: "https://www.bbc.co.uk/_web_core?foo=bar",
                               payload: "",
                               headers: %{"accept-encoding" => "gzip", "x-country" => "gb", "user-agent" => "Belfrage"}
                             } ->
        {:ok,
         %Belfrage.Clients.HTTP.Response{
           status_code: 500,
           headers: %{"content-type" => "text/plain"},
           body: "500 - Internal Server Error"
         }}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: "500 - Internal Server Error"
               }
             } = HTTP.dispatch(@get_struct)
    end

    test "Cannot connect to origin" do
      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Belfrage.Clients.HTTP.Request{
             method: :get,
             url: "https://www.bbc.co.uk/_web_core?foo=bar",
             payload: "",
             headers: %{"accept-encoding" => "gzip", "x-country" => "gb", "user-agent" => "Belfrage"}
           } ->
          {
            :error,
            %Belfrage.Clients.HTTP.Error{
              reason: :failed_to_connect
            }
          }
        end
      )

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: "",
                 headers: %{}
               }
             } = HTTP.dispatch(@get_struct)
    end

    test "origin times out" do
      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Belfrage.Clients.HTTP.Request{
             method: :get,
             url: "https://www.bbc.co.uk/_web_core?foo=bar",
             payload: "",
             headers: %{"accept-encoding" => "gzip", "x-country" => "gb", "user-agent" => "Belfrage"}
           } ->
          {
            :error,
            %Belfrage.Clients.HTTP.Error{reason: :timeout}
          }
        end
      )

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: ""
               }
             } = HTTP.dispatch(@get_struct)
    end

    test "when varnish is set, the varnish header is used" do
      struct = %Struct{
        private: %Struct.Private{
          origin: "https://www.bbc.co.uk"
        },
        request: %Struct.Request{
          method: "GET",
          path: "/_web_core",
          country: "gb",
          host: "www.bbc.co.uk"
        }
      }

      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Belfrage.Clients.HTTP.Request{
             method: :get,
             url: "https://www.bbc.co.uk/_web_core",
             payload: "",
             headers: %{
               "accept-encoding" => "gzip",
               "x-country" => "gb",
               "user-agent" => "Belfrage",
               "x-forwarded-host" => "www.bbc.co.uk"
             }
           } ->
          @ok_response
        end
      )

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = HTTP.dispatch(struct)
    end

    test "when the raw headers are set, the raw headers are used" do
      struct = %Struct{
        private: %Struct.Private{
          origin: "https://www.bbc.co.uk"
        },
        request: %Struct.Request{
          method: "GET",
          path: "/_web_core",
          country: "gb",
          host: "www.bbc.co.uk",
          raw_headers: %{
            "raw-header" => "val"
          }
        }
      }

      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Belfrage.Clients.HTTP.Request{
             method: :get,
             url: "https://www.bbc.co.uk/_web_core",
             payload: "",
             headers: %{
               "accept-encoding" => "gzip",
               "x-country" => "gb",
               "user-agent" => "Belfrage",
               "x-forwarded-host" => "www.bbc.co.uk",
               "raw-header" => "val"
             }
           } ->
          @ok_response
        end
      )

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = HTTP.dispatch(struct)
    end

    test "when edge cache is set, the edge cache request headers are used" do
      struct = %Struct{
        private: %Struct.Private{
          origin: "https://www.bbc.co.uk"
        },
        request: %Struct.Request{
          method: "GET",
          path: "/_web_core",
          country: "gb",
          host: "www.bbc.co.uk",
          edge_cache?: true,
          scheme: :https,
          is_uk: true
        }
      }

      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Belfrage.Clients.HTTP.Request{
             method: :get,
             url: "https://www.bbc.co.uk/_web_core",
             payload: "",
             headers: %{
               "accept-encoding" => "gzip",
               "x-bbc-edge-cache" => "1",
               "x-bbc-edge-country" => "gb",
               "x-bbc-edge-host" => "www.bbc.co.uk",
               "x-bbc-edge-isuk" => "yes",
               "x-bbc-edge-scheme" => "https",
               "user-agent" => "Belfrage"
             }
           } ->
          @ok_response
        end
      )

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = HTTP.dispatch(struct)
    end
  end
end
