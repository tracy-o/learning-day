defmodule Belfrage.Services.HTTPTest do
  alias Belfrage.Clients
  alias Belfrage.Services.HTTP
  alias Belfrage.Envelope
  alias Belfrage.Metrics.LatencyMonitor
  alias Belfrage.Test.XrayHelper

  import ExUnit.CaptureLog
  import Belfrage.Test.MetricsHelper

  use ExUnit.Case
  use Test.Support.Helper, :mox

  @get_envelope %Envelope{
    private: %Envelope.Private{
      origin: "https://www.bbc.co.uk",
      platform: "SomePlatform"
    },
    request: %Envelope.Request{
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

  defmodule TestPlug do
    import Plug.Conn

    def init(_), do: []

    def call(conn, _opts) do
      send_resp(conn, 200, get_req_header(conn, "referer"))
    end
  end

  describe "HTTP service" do
    test "get returns a response" do
      expect_request(
        %Clients.HTTP.Request{
          method: :get,
          url: "https://www.bbc.co.uk/_some_path?foo=bar",
          headers: %{
            "accept-encoding" => "gzip",
            "x-country" => "gb",
            "user-agent" => "Belfrage",
            "x-forwarded-host" => "www.bbc.co.uk",
            "req-svc-chain" => "BELFRAGE",
            "bbc-origin" => "https://www.bbc.co.uk"
          }
        },
        @ok_response
      )

      assert %Envelope{
               response: %Envelope.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = HTTP.dispatch(@get_envelope)
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
          headers: %{
            "accept-encoding" => "gzip",
            "x-country" => "gb",
            "user-agent" => "Belfrage"
          }
        },
        response
      )

      assert %Envelope{
               response: %Envelope.Response{
                 http_status: 500,
                 body: "500 - Internal Server Error"
               }
             } = HTTP.dispatch(@get_envelope)
    end

    test "Cannot connect to origin" do
      response = {:error, %Clients.HTTP.Error{reason: :failed_to_connect}}

      expect_request(
        %Clients.HTTP.Request{
          method: :get,
          url: "https://www.bbc.co.uk/_some_path?foo=bar",
          headers: %{"accept-encoding" => "gzip", "x-country" => "gb", "user-agent" => "Belfrage"}
        },
        response
      )

      assert %Envelope{
               response: %Envelope.Response{
                 http_status: 500,
                 body: "",
                 headers: %{}
               }
             } = HTTP.dispatch(@get_envelope)
    end

    test "invalid path" do
      expect_request(
        %Clients.HTTP.Request{
          method: :get,
          url: "https://www.bbc.co.uk/invalid\\path",
          headers: %{"accept-encoding" => "gzip", "x-country" => "gb", "user-agent" => "Belfrage"}
        },
        {:error, %Clients.HTTP.Error{reason: :invalid_request_target}}
      )

      assert %Envelope{
               response: %Envelope.Response{
                 http_status: 404,
                 body: ""
               }
             } =
               HTTP.dispatch(%Envelope{
                 private: %Envelope.Private{
                   origin: "https://www.bbc.co.uk",
                   platform: "SomePlatform"
                 },
                 request: %Envelope.Request{
                   method: "GET",
                   path: "/invalid\\path",
                   query_params: %{},
                   country: "gb",
                   host: "www.bbc.co.uk",
                   req_svc_chain: "BELFRAGE"
                 }
               })
    end

    defp do_not_mock_http_client() do
      previous = Application.get_env(:belfrage, :http_client)
      Application.put_env(:belfrage, :http_client, Belfrage.Clients.HTTP)

      on_exit(fn ->
        Application.put_env(:belfrage, :http_client, previous)
      end)
    end

    defp do_not_mock_finch() do
      previous = Application.get_env(:belfrage, :finch_impl)
      Application.put_env(:belfrage, :finch_impl, Finch)

      on_exit(fn ->
        Application.put_env(:belfrage, :finch_impl, previous)
      end)
    end

    defp random_port() do
      with {:ok, socket} <- :gen_udp.open(0, [:binary, active: false]),
           {:ok, port} <- :inet.port(socket) do
        port
      end
    end

    test "can handle non-ascii characters in header value" do
      do_not_mock_http_client()
      do_not_mock_finch()

      port = random_port()

      start_supervised({Plug.Cowboy, scheme: :http, plug: TestPlug, options: [port: port]})

      referer = "https://fa.wikipedia.org/wiki/۲۰۰۸"
      urlencoded_referer = URI.encode(referer)

      assert %Envelope{response: %Envelope.Response{http_status: 200, body: ^urlencoded_referer}} =
               HTTP.dispatch(%Envelope{
                 private: %Envelope.Private{
                   origin: "http://localhost:#{port}",
                   platform: "SomePlatform"
                 },
                 request: %Envelope.Request{
                   method: "GET",
                   path: "/some-path",
                   query_params: %{},
                   referer: referer,
                   host: "localhost",
                   req_svc_chain: "BELFRAGE"
                 }
               })
    end

    test "when origin times out a 500 response is returned" do
      do_not_mock_http_client()

      FinchMock
      |> expect(:request, fn _request, Finch, _opts ->
        {:error, %Mint.TransportError{reason: :timeout}}
      end)

      assert %Envelope{
               response: %Envelope.Response{
                 http_status: 500,
                 body: ""
               }
             } = HTTP.dispatch(@get_envelope)
    end

    test "when origin times out the client error is logged as a warning" do
      do_not_mock_http_client()

      FinchMock
      |> expect(:request, fn _request, Finch, _opts ->
        {:error, %Mint.TransportError{reason: :timeout}}
      end)

      assert capture_log([level: :warn], fn -> HTTP.dispatch(@get_envelope) end) =~
               "\"third_party_reason\":\"timeout\",\"info\":\"Http error\",\"belfrage_http_reason\":\"timeout\""

      FinchMock
      |> expect(:request, fn _request, Finch, _opts ->
        {:error, %Mint.TransportError{reason: :timeout}}
      end)

      refute capture_log([level: :error], fn -> HTTP.dispatch(@get_envelope) end) =~
               "\"third_party_reason\":\"timeout\",\"info\":\"Http error\",\"belfrage_http_reason\":\"timeout\""
    end

    test "when origin times out a service error is logged as a warning" do
      do_not_mock_http_client()

      FinchMock
      |> expect(:request, fn _request, Finch, _opts ->
        {:error, %Mint.TransportError{reason: :timeout}}
      end)

      assert capture_log([level: :warn], fn -> HTTP.dispatch(@get_envelope) end) =~
               "\"reason\":\"timeout\",\"msg\":\"HTTP Service request error\""

      FinchMock
      |> expect(:request, fn _request, Finch, _opts ->
        {:error, %Mint.TransportError{reason: :timeout}}
      end)

      refute capture_log([level: :error], fn -> HTTP.dispatch(@get_envelope) end) =~
               "\"reason\":\"timeout\",\"msg\":\"HTTP Service request error\""
    end

    test "when origin times out a telemetry event is sent" do
      do_not_mock_http_client()

      FinchMock
      |> expect(:request, fn _request, Finch, _opts ->
        {:error, %Mint.TransportError{reason: :timeout}}
      end)

      assert_metric(
        {[:error, :service, :SomePlatform, :timeout], %{count: 1}, %{platform: :SomePlatform, status_code: "408"}},
        fn -> HTTP.dispatch(@get_envelope) end
      )
    end

    test "when the URI contains a char that is not allowed to be unescaped a 404 response is returned" do
      do_not_mock_http_client()
      do_not_mock_finch()
      port = random_port()

      start_supervised({Plug.Cowboy, scheme: :http, plug: TestPlug, options: [port: port]})

      assert assert %Envelope{
                      response: %Envelope.Response{
                        http_status: 404,
                        body: ""
                      }
                    } =
                      HTTP.dispatch(%Envelope{
                        private: %Envelope.Private{
                          origin: "http://localhost:#{port}",
                          platform: "SomePlatform"
                        },
                        request: %Envelope.Request{
                          method: "GET",
                          path: "/some-path/?{",
                          query_params: %{},
                          host: "localhost",
                          req_svc_chain: "BELFRAGE"
                        }
                      })
    end

    test "when the URI contains a char that is not allowed to be unescaped a client error is logged as a warning" do
      do_not_mock_http_client()
      do_not_mock_finch()
      port = random_port()

      start_supervised({Plug.Cowboy, scheme: :http, plug: TestPlug, options: [port: port]})

      assert capture_log([level: :warn], fn ->
               HTTP.dispatch(%Envelope{
                 private: %Envelope.Private{
                   origin: "http://localhost:#{port}",
                   platform: "SomePlatform"
                 },
                 request: %Envelope.Request{
                   method: "GET",
                   path: "/some-path/?{",
                   query_params: %{},
                   host: "localhost",
                   req_svc_chain: "BELFRAGE"
                 }
               })
             end) =~
               "\"third_party_reason\":\"invalid request target: \\\"/some-path/?{\\\"\",\"info\":\"Http error\",\"belfrage_http_reason\":\"invalid_request_target\""

      refute capture_log([level: :error], fn ->
               HTTP.dispatch(%Envelope{
                 private: %Envelope.Private{
                   origin: "http://localhost:#{port}",
                   platform: "SomePlatform"
                 },
                 request: %Envelope.Request{
                   method: "GET",
                   path: "/some-path/?{",
                   query_params: %{},
                   host: "localhost",
                   req_svc_chain: "BELFRAGE"
                 }
               })
             end) =~
               "\"third_party_reason\":\"invalid request target: \\\"/some-path/?{\\\"\",\"info\":\"Http error\",\"belfrage_http_reason\":\"invalid_request_target\""
    end

    test "when the URI contains a char that is not allowed to be unescaped a telemetry event is sent" do
      do_not_mock_http_client()
      do_not_mock_finch()
      port = random_port()

      start_supervised({Plug.Cowboy, scheme: :http, plug: TestPlug, options: [port: port]})

      assert_metric(
        {[:http, :client, :error, :invalid_request_target], %{count: 1}, %{}},
        fn ->
          HTTP.dispatch(%Envelope{
            private: %Envelope.Private{
              origin: "http://localhost:#{port}",
              platform: "SomePlatform"
            },
            request: %Envelope.Request{
              method: "GET",
              path: "/some-path/?{",
              query_params: %{},
              host: "localhost",
              req_svc_chain: "BELFRAGE"
            }
          })
        end
      )
    end

    test "when the URI contains a char that is not allowed to be unescaped a metric is sent" do
      do_not_mock_http_client()
      do_not_mock_finch()
      port = random_port()

      start_supervised({Plug.Cowboy, scheme: :http, plug: TestPlug, options: [port: port]})

      {socket, udp_port} = given_udp_port_opened()

      start_reporter(
        metrics: Belfrage.Metrics.Statsd.statix_static_metrics(),
        formatter: :datadog,
        global_tags: [BBCEnvironment: "live"],
        port: udp_port
      )

      HTTP.dispatch(%Envelope{
        private: %Envelope.Private{
          origin: "http://localhost:#{port}",
          platform: "SomePlatform"
        },
        request: %Envelope.Request{
          method: "GET",
          path: "/some-path/?{",
          query_params: %{},
          host: "localhost",
          req_svc_chain: "BELFRAGE"
        }
      })

      assert_reported(
        socket,
        "http.client.error.invalid_request_target:1|c|#BBCEnvironment:live"
      )
    end

    test "when varnish is set, the varnish header is used" do
      envelope = %Envelope{
        private: %Envelope.Private{
          origin: "https://www.bbc.co.uk",
          platform: "SomePlatform"
        },
        request: %Envelope.Request{
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
          headers: %{
            "accept-encoding" => "gzip",
            "x-country" => "gb",
            "user-agent" => "Belfrage",
            "x-forwarded-host" => "www.bbc.co.uk"
          }
        },
        @ok_response
      )

      assert %Envelope{
               response: %Envelope.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = HTTP.dispatch(envelope)
    end

    test "when the raw headers are set, the raw headers are used" do
      envelope = %Envelope{
        private: %Envelope.Private{
          origin: "https://www.bbc.co.uk",
          platform: "SomePlatform"
        },
        request: %Envelope.Request{
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

      assert %Envelope{
               response: %Envelope.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = HTTP.dispatch(envelope)
    end

    test "when edge cache is set, the edge cache request headers are used" do
      envelope = %Envelope{
        private: %Envelope.Private{
          origin: "https://www.bbc.co.uk",
          platform: "SomePlatform"
        },
        request: %Envelope.Request{
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

      assert %Envelope{
               response: %Envelope.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = HTTP.dispatch(envelope)
    end

    test "when advertise is set, the bbc adverts header is used" do
      envelope = %Envelope{
        private: %Envelope.Private{
          origin: "https://www.bbc.com",
          platform: "SomePlatform"
        },
        request: %Envelope.Request{
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

      assert %Envelope{
               response: %Envelope.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = HTTP.dispatch(envelope)
    end

    test "when xray_segment present, 'x-amzn-trace-id' us used" do
      envelope = %Envelope{
        private: %Envelope.Private{
          origin: "https://www.bbc.co.uk",
          platform: "SomePlatform"
        },
        request: %Envelope.Request{
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

      assert %Envelope{
               response: %Envelope.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = HTTP.dispatch(envelope)
    end

    test "when mvt headers are present, they are put in the request headers" do
      expected_mvt_headers = %{
        "mvt-button_colour" => {1, "experiment;red"},
        "mvt-sidebar" => {3, "feature;false"}
      }

      envelope = %Envelope{
        private: %Envelope.Private{
          origin: "https://www.bbc.co.uk",
          platform: "SomePlatform",
          mvt: expected_mvt_headers
        },
        request: %Envelope.Request{
          method: "GET",
          path: "/_some_path",
          country: "gb",
          host: "www.bbc.co.uk",
          edge_cache?: true,
          scheme: :https,
          is_uk: true
        }
      }

      Clients.HTTPMock
      |> expect(:execute, fn %Clients.HTTP.Request{headers: actual_headers}, _pool ->
        for {key, _value} <- expected_mvt_headers do
          assert Map.get(actual_headers, key)
        end

        @ok_response
      end)

      assert %Envelope{
               response: %Envelope.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}",
                 headers: %{"content-type" => "application/json"}
               }
             } = HTTP.dispatch(envelope)
    end

    test "tracks latency checkpoints" do
      request_id = UUID.uuid4(:hex)
      envelope = Envelope.add(@get_envelope, :request, %{request_id: request_id})

      stub_request()
      envelope = HTTP.dispatch(envelope)
      assert_successful_response(envelope)

      checkpoints = LatencyMonitor.get_checkpoints(envelope)
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
      assert %Envelope{response: %{http_status: 200}} = response
    end
  end
end
