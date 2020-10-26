defmodule Belfrage.Services.FablTest do
  alias Belfrage.Clients
  alias Belfrage.Services.Fabl
  alias Belfrage.Struct

  use ExUnit.Case
  use Test.Support.Helper, :mox

  @get_struct %Struct{
    private: %Struct.Private{
      origin: "https://fabl.test.api.bbci.co.uk"
    },
    request: %Struct.Request{
      method: "GET",
      path: "/fd/example-module",
      path_params: %{
        "name" => "example-module"
      },
      raw_headers: %{
        "a-header" => "a value"
      },
      xray_trace_id: "xxxx-yyyyyyyyyy-1",
      req_svc_chain: "BELFRAGE"
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

  describe "Fabl service" do
    test "get returns a response" do
      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Belfrage.Clients.HTTP.Request{
             method: :get,
             url: "https://fabl.test.api.bbci.co.uk/module/example-module",
             payload: "",
             headers: %{"accept-encoding" => "gzip", "user-agent" => "Belfrage", "req-svc-chain" => "BELFRAGE"}
           },
           :fabl ->
          @ok_response
        end
      )

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = Fabl.dispatch(@get_struct)
    end

    test "origin returns a 500 response" do
      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Belfrage.Clients.HTTP.Request{
             method: :get,
             url: "https://fabl.test.api.bbci.co.uk/module/example-module",
             payload: "",
             headers: %{"accept-encoding" => "gzip", "user-agent" => "Belfrage", "req-svc-chain" => "BELFRAGE"}
           },
           :fabl ->
          {:ok,
           %Belfrage.Clients.HTTP.Response{
             status_code: 500,
             headers: %{"content-type" => "text/plain"},
             body: "500 - Internal Server Error"
           }}
        end
      )

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: "500 - Internal Server Error"
               }
             } = Fabl.dispatch(@get_struct)
    end

    test "Cannot connect to origin" do
      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Belfrage.Clients.HTTP.Request{
             method: :get,
             url: "https://fabl.test.api.bbci.co.uk/module/example-module",
             payload: "",
             headers: %{"accept-encoding" => "gzip", "user-agent" => "Belfrage", "req-svc-chain" => "BELFRAGE"}
           },
           :fabl ->
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
             } = Fabl.dispatch(@get_struct)
    end

    test "origin times out" do
      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Belfrage.Clients.HTTP.Request{
             method: :get,
             url: "https://fabl.test.api.bbci.co.uk/module/example-module",
             payload: "",
             headers: %{"accept-encoding" => "gzip", "user-agent" => "Belfrage", "req-svc-chain" => "BELFRAGE"}
           },
           :fabl ->
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
             } = Fabl.dispatch(@get_struct)
    end

    @get_preview_struct %Struct{
      private: %Struct.Private{
        origin: "https://fabl.test.api.bbci.co.uk"
      },
      request: %Struct.Request{
        method: "GET",
        path: "/fd/preview/example-preview-module",
        path_params: %{
          "name" => "example-preview-module"
        },
        req_svc_chain: "BELFRAGE"
      }
    }

    test "when requesting a preview module it returns a response" do
      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Belfrage.Clients.HTTP.Request{
             method: :get,
             url: "https://fabl.test.api.bbci.co.uk/preview/module/example-preview-module",
             payload: "",
             headers: %{"accept-encoding" => "gzip", "user-agent" => "Belfrage", "req-svc-chain" => "BELFRAGE"}
           },
           :fabl ->
          @ok_response
        end
      )

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = Fabl.dispatch(@get_preview_struct)
    end

    @get_preview_with_query_struct %Struct{
      private: %Struct.Private{
        origin: "https://fabl.test.api.bbci.co.uk"
      },
      request: %Struct.Request{
        method: "GET",
        path: "/fd/preview/example-preview-module?subText=readable",
        path_params: %{
          "name" => "example-preview-module"
        },
        query_params: %{
          "subText" => "readable"
        },
        req_svc_chain: "BELFRAGE"
      }
    }

    test "when requesting a preview module with a query string it returns a response" do
      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Belfrage.Clients.HTTP.Request{
             method: :get,
             url: "https://fabl.test.api.bbci.co.uk/preview/module/example-preview-module?subText=readable",
             payload: "",
             headers: %{"accept-encoding" => "gzip", "user-agent" => "Belfrage", "req-svc-chain" => "BELFRAGE"}
           },
           :fabl ->
          @ok_response
        end
      )

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = Fabl.dispatch(@get_preview_with_query_struct)
    end

    test "sends raw_header values" do
      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Belfrage.Clients.HTTP.Request{
             method: _method,
             url: _url,
             payload: _payload,
             headers: %{
               "a-header" => "a value",
               "accept-encoding" => "gzip",
               "user-agent" => "Belfrage",
               "req-svc-chain" => "BELFRAGE"
             }
           },
           :fabl ->
          @ok_response
        end
      )

      Fabl.dispatch(@get_struct)
    end

    test "passes non nil xray-trace-id" do
      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Belfrage.Clients.HTTP.Request{
             method: _method,
             url: _url,
             payload: _payload,
             headers: %{
               "x-amzn-trace-id" => "xxxx-yyyyyyyyyy-1",
               "accept-encoding" => "gzip",
               "user-agent" => "Belfrage",
               "req-svc-chain" => "BELFRAGE"
             }
           },
           :fabl ->
          @ok_response
        end
      )

      Fabl.dispatch(@get_struct)
    end

    @get_nil_xray_struct %Struct{
      private: %Struct.Private{
        origin: "https://fabl.test.api.bbci.co.uk"
      },
      request: %Struct.Request{
        method: "GET",
        path: "/fd/example-module",
        path_params: %{
          "name" => "example-module"
        },
        raw_headers: %{
          "a-header" => "a value"
        },
        xray_trace_id: nil,
        req_svc_chain: "BELFRAGE"
      }
    }

    test "does not pass nil xray-trace-id " do
      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Belfrage.Clients.HTTP.Request{
             method: _method,
             url: _url,
             payload: _payload,
             headers: headers
           },
           :fabl ->
          refute Map.has_key?(headers, "x-amzn-trace-id")
          @ok_response
        end
      )

      Fabl.dispatch(@get_nil_xray_struct)
    end
  end
end
