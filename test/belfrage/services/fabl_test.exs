defmodule Belfrage.Services.FablTest do
  alias Belfrage.Clients
  alias Belfrage.Services.Fabl
  alias Belfrage.Struct

  use ExUnit.Case
  use Test.Support.Helper, :mox
  use Belfrage.Test.XrayHelper

  @valid_session %Struct.UserSession{
    authentication_env: "int",
    session_token: "a-valid-session-token",
    authenticated: true,
    valid_session: true,
    user_attributes: %{age_bracket: "o18", allow_personalisation: true}
  }

  @unauthenticated_session %Struct.UserSession{
    authentication_env: "int",
    session_token: nil,
    authenticated: false,
    valid_session: false,
    user_attributes: %{}
  }

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
    test "get handles a non personalised request and returns a successful response" do
      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Belfrage.Clients.HTTP.Request{
             method: :get,
             url: "https://fabl.test.api.bbci.co.uk/module/example-module",
             payload: "",
             headers: %{"accept-encoding" => "gzip", "user-agent" => "Belfrage", "req-svc-chain" => "BELFRAGE"}
           },
           :Fabl ->
          @ok_response
        end
      )

      struct = Struct.add(@get_struct, :user_session, @unauthenticated_session)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = Fabl.dispatch(struct)
    end

    test "get handles a valid personalised request and returns a successful response" do
      Clients.HTTPMock
      |> expect(
        :execute,
        fn %Belfrage.Clients.HTTP.Request{
             method: :get,
             url: "https://fabl.test.api.bbci.co.uk/module/example-module",
             payload: "",
             headers: %{"accept-encoding" => "gzip", "user-agent" => "Belfrage", "req-svc-chain" => "BELFRAGE"}
           },
           :Fabl ->
          @ok_response
        end
      )

      struct = Struct.add(@get_struct, :user_session, @valid_session)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = Fabl.dispatch(struct)
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
           :Fabl ->
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
           :Fabl ->
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
           :Fabl ->
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
           :Fabl ->
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
           :Fabl ->
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
           :Fabl ->
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
               "x-amzn-trace-id" => trace_id,
               "accept-encoding" => "gzip",
               "user-agent" => "Belfrage",
               "req-svc-chain" => "BELFRAGE"
             }
           },
           :Fabl ->
          assert trace_id
          @ok_response
        end
      )

      struct = put_in(@get_struct.request.xray_segment, build_segment(sampled: true))
      Fabl.dispatch(struct)
    end

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
           :Fabl ->
          refute Map.has_key?(headers, "x-amzn-trace-id")
          @ok_response
        end
      )

      Fabl.dispatch(@get_struct)
    end
  end
end
