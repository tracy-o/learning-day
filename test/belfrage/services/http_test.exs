defmodule Belfrage.Services.HTTPTest do
  alias Belfrage.Clients
  alias Belfrage.Services.HTTP
  alias Belfrage.Struct
  alias Belfrage.Metrics.LatencyMonitor
  alias Belfrage.Test.XrayHelper

  use ExUnit.Case
  use Test.Support.Helper, :mox

  @get_struct %Struct{
    private: %Struct.Private{
      origin: "https://www.bbc.co.uk",
      platform: SomePlatform
    },
    request: %Struct.Request{
      method: "GET",
      path: "/_some_path",
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
      origin: "https://www.bbc.co.uk",
      platform: SomePlatform
    },
    request: %Struct.Request{
      payload: ~s({"some": "data"}),
      path: "/_some_path",
      method: "POST",
      country: "gb",
      query_params: %{
        "foo" => "bar"
      }
    }
  }

  @ok_response {
    :ok,
    %Clients.HTTP.Response{
      status_code: 200,
      headers: %{"content-type" => "application/json"},
      body: ~s({"some": "body"})
    }
  }

  defmacro expect_request(request, response) do
    quote do
      expect(Clients.HTTPMock, :execute, fn unquote(request), _ -> unquote(response) end)
    end
  end

  describe "HTTP service" do
    test "get returns a response" do
      expect_request(
        %Clients.HTTP.Request{
          method: :get,
          url: "https://www.bbc.co.uk/_some_path?foo=bar",
          payload: "",
          headers: %{
            "accept-encoding" => "gzip",
            "x-country" => "gb",
            "user-agent" => "Belfrage",
            "x-forwarded-host" => "www.bbc.co.uk",
            "req-svc-chain" => "BELFRAGE"
          }
        },
        @ok_response
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
      expect_request(
        %Clients.HTTP.Request{
          method: :post,
          url: "https://www.bbc.co.uk/_some_path?foo=bar",
          payload: ~s({"some": "data"}),
          headers: %{"accept-encoding" => "gzip", "x-country" => "gb", "user-agent" => "Belfrage"}
        },
        @ok_response
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
      response =
        {:ok,
         %Clients.HTTP.Response{
           status_code: 500,
           headers: %{"content-type" => "text/plain"},
           body: "500 - Internal Server Error"
         }}

      expect_request(
        %Clients.HTTP.Request{
          method: :get,
          url: "https://www.bbc.co.uk/_some_path?foo=bar",
          payload: "",
          headers: %{
            "accept-encoding" => "gzip",
            "x-country" => "gb",
            "user-agent" => "Belfrage"
          }
        },
        response
      )

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: "500 - Internal Server Error"
               }
             } = HTTP.dispatch(@get_struct)
    end

    test "Cannot connect to origin" do
      response = {:error, %Clients.HTTP.Error{reason: :failed_to_connect}}

      expect_request(
        %Clients.HTTP.Request{
          method: :get,
          url: "https://www.bbc.co.uk/_some_path?foo=bar",
          payload: "",
          headers: %{"accept-encoding" => "gzip", "x-country" => "gb", "user-agent" => "Belfrage"}
        },
        response
      )

      assert %Struct{
               response: %Struct.Response{
                 http_status: 500,
                 body: "",
                 headers: %{}
               }
             } = HTTP.dispatch(@get_struct)
    end

    test "invalid path" do
      expect_request(
        %Clients.HTTP.Request{
          method: :get,
          url: "https://www.bbc.co.uk/invalid\\path",
          payload: "",
          headers: %{"accept-encoding" => "gzip", "x-country" => "gb", "user-agent" => "Belfrage"}
        },
        {:error, %Clients.HTTP.Error{reason: :invalid_request_target}}
      )

      assert %Struct{
               response: %Struct.Response{
                 http_status: 404,
                 body: ""
               }
             } =
               HTTP.dispatch(%Struct{
                 private: %Struct.Private{
                   origin: "https://www.bbc.co.uk",
                   platform: SomePlatform
                 },
                 request: %Struct.Request{
                   method: "GET",
                   path: "/invalid\\path",
                   query_params: %{},
                   country: "gb",
                   host: "www.bbc.co.uk",
                   req_svc_chain: "BELFRAGE"
                 }
               })
    end

    defp dont_mock_http_client() do
      previous = Application.get_env(:belfrage, :http_client)
      Application.put_env(:belfrage, :http_client, Belfrage.Clients.HTTP)

      on_exit(fn ->
        Application.put_env(:belfrage, :http_client, previous)
      end)
    end

    test "invalid header value" do
      dont_mock_http_client()

      expect(FinchMock, :request, fn _req, _name, _opts ->
        {:error, %Mint.HTTPError{reason: {:invalid_header_value, "referer", "oops"}}}
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 400,
                 body: ""
               }
             } =
               HTTP.dispatch(%Struct{
                 private: %Struct.Private{
                   origin: "https://www.bbc.co.uk",
                   platform: SomePlatform
                 },
                 request: %Struct.Request{
                   method: "GET",
                   path: "/some-path",
                   query_params: %{},
                   country: "not\0allowed",
                   host: "www.bbc.co.uk",
                   req_svc_chain: "BELFRAGE"
                 }
               })
    end

    test "origin times out" do
      response = {:error, %Clients.HTTP.Error{reason: :timeout}}

      expect_request(
        %Clients.HTTP.Request{
          method: :get,
          url: "https://www.bbc.co.uk/_some_path?foo=bar",
          payload: "",
          headers: %{"accept-encoding" => "gzip", "x-country" => "gb", "user-agent" => "Belfrage"}
        },
        response
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
          origin: "https://www.bbc.co.uk",
          platform: SomePlatform
        },
        request: %Struct.Request{
          method: "GET",
          path: "/_some_path",
          country: "gb",
          host: "www.bbc.co.uk"
        }
      }

      expect_request(
        %Clients.HTTP.Request{
          method: :get,
          url: "https://www.bbc.co.uk/_some_path",
          payload: "",
          headers: %{
            "accept-encoding" => "gzip",
            "x-country" => "gb",
            "user-agent" => "Belfrage",
            "x-forwarded-host" => "www.bbc.co.uk"
          }
        },
        @ok_response
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
          origin: "https://www.bbc.co.uk",
          platform: SomePlatform
        },
        request: %Struct.Request{
          method: "GET",
          path: "/_some_path",
          country: "gb",
          host: "www.bbc.co.uk",
          raw_headers: %{
            "raw-header" => "val"
          }
        }
      }

      expect_request(
        %Clients.HTTP.Request{
          method: :get,
          url: "https://www.bbc.co.uk/_some_path",
          payload: "",
          headers: %{
            "accept-encoding" => "gzip",
            "x-country" => "gb",
            "user-agent" => "Belfrage",
            "x-forwarded-host" => "www.bbc.co.uk",
            "raw-header" => "val"
          }
        },
        @ok_response
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
          origin: "https://www.bbc.co.uk",
          platform: SomePlatform
        },
        request: %Struct.Request{
          method: "GET",
          path: "/_some_path",
          country: "gb",
          host: "www.bbc.co.uk",
          edge_cache?: true,
          scheme: :https,
          is_uk: true
        }
      }

      expect_request(
        %Clients.HTTP.Request{
          method: :get,
          url: "https://www.bbc.co.uk/_some_path",
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
        },
        @ok_response
      )

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = HTTP.dispatch(struct)
    end

    test "when advertise is set, the bbc adverts header is used" do
      struct = %Struct{
        private: %Struct.Private{
          origin: "https://www.bbc.com",
          platform: SomePlatform
        },
        request: %Struct.Request{
          method: "GET",
          path: "/_some_path",
          country: "kg",
          host: "www.bbc.com",
          edge_cache?: true,
          scheme: :https,
          is_uk: false,
          is_advertise: true
        }
      }

      expect_request(
        %Clients.HTTP.Request{
          method: :get,
          url: "https://www.bbc.com/_some_path",
          payload: "",
          headers: %{
            "accept-encoding" => "gzip",
            "x-bbc-edge-cache" => "1",
            "x-bbc-edge-country" => "kg",
            "x-bbc-edge-host" => "www.bbc.com",
            "x-bbc-edge-scheme" => "https",
            "bbc-adverts" => "true",
            "user-agent" => "Belfrage"
          }
        },
        @ok_response
      )

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = HTTP.dispatch(struct)
    end

    test "when xray_segment present, 'x-amzn-trace-id' us used" do
      struct = %Struct{
        private: %Struct.Private{
          origin: "https://www.bbc.co.uk",
          platform: SomePlatform
        },
        request: %Struct.Request{
          method: "GET",
          path: "/_some_path",
          country: "gb",
          host: "www.bbc.co.uk",
          edge_cache?: true,
          scheme: :https,
          is_uk: true,
          xray_segment: XrayHelper.build_segment(sampled: false)
        }
      }

      Clients.HTTPMock
      |> expect(:execute, fn %Clients.HTTP.Request{headers: %{"x-amzn-trace-id" => trace_header}}, _pool ->
        assert_xray_trace(trace_header)
        @ok_response
      end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = HTTP.dispatch(struct)
    end

    test "tracks latency checkpoints" do
      request_id = UUID.uuid4(:hex)
      struct = Struct.add(@get_struct, :request, %{request_id: request_id})

      stub_request()
      struct = HTTP.dispatch(struct)
      assert_successful_response(struct)

      checkpoints = LatencyMonitor.get_checkpoints(struct)
      assert checkpoints[:origin_request_sent]
      assert checkpoints[:origin_response_received]
      assert checkpoints[:origin_response_received] > checkpoints[:origin_request_sent]
    end

    defp assert_xray_trace(trace_header) do
      split_trace =
        trace_header
        |> String.split(";")
        |> Enum.map(&String.split(&1, "="))

      assert [["Root", _root], ["Parent", _parent], ["Sampled", _sampled]] = split_trace
    end

    defp stub_request() do
      stub(Clients.HTTPMock, :execute, fn _, _ -> @ok_response end)
    end

    defp assert_successful_response(response) do
      assert %Struct{response: %{http_status: 200}} = response
    end
  end
end
