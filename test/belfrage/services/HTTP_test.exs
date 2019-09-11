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
      query_params: %{
        "foo" => "bar"
      }
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
      query_params: %{
        "foo" => "bar"
      }
    }
  }

  @ok_response {
    :ok,
    %Mojito.Response{
      status_code: 200,
      headers: [{"content-type", "application/json"}],
      body: "{\"some\": \"body\"}"
    }
  }

  describe "HTTP service" do
    test "get returns a response" do
      Clients.HTTPMock
      |> expect(:request, fn :get, "https://www.bbc.co.uk/_web_core?foo=bar" -> @ok_response end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}"
               }
             } = HTTP.dispatch(@get_struct)
    end

    test "post returns a response" do
      Clients.HTTPMock
      |> expect(:request, fn :post, "https://www.bbc.co.uk/_web_core?foo=bar", ~s({"some": "data"}) -> @ok_response end)

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}"
               }
             } = HTTP.dispatch(@post_struct)
    end

    test "origin returns a 500 response" do
      Clients.HTTPMock
      |> expect(
        :request,
        fn :get, "https://www.bbc.co.uk/_web_core?foo=bar" ->
          {
            :ok,
            %Mojito.Response{
              status_code: 500,
              headers: [{"content-type", "text/plain"}],
              body: "500 - Internal Server Error"
            }
          }
        end
      )

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
        :request,
        fn :get, "https://www.bbc.co.uk/_web_core?foo=bar" ->
          {
            :error,
            %Mojito.Error{
              message: nil,
              reason: %Mint.TransportError{
                reason: {:tls_alert, 'unknown ca'}
              }
            }
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

    test "origin times out" do
      Clients.HTTPMock
      |> expect(
        :request,
        fn :get, "https://www.bbc.co.uk/_web_core?foo=bar" ->
          {
            :error,
            %Mojito.Error{message: nil, reason: :timeout}
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
  end
end
