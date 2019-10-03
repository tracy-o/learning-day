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
    %Belfrage.Clients.HTTP.Response{
      status_code: 200,
      headers: [{"content-type", "application/json"}],
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
             headers: []
           } ->
          @ok_response
        end
      )

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}"
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
             headers: []
           } ->
          @ok_response
        end
      )

      assert %Struct{
               response: %Struct.Response{
                 http_status: 200,
                 body: "{\"some\": \"body\"}"
               }
             } = HTTP.dispatch(@post_struct)
    end

    test "origin returns a 500 response" do
      Clients.HTTPMock
      |> expect(:execute, fn %Belfrage.Clients.HTTP.Request{
                               method: :get,
                               url: "https://www.bbc.co.uk/_web_core?foo=bar",
                               payload: "",
                               headers: []
                             } ->
        {:ok,
         %Belfrage.Clients.HTTP.Response{
           status_code: 500,
           headers: [{"content-type", "text/plain"}],
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
             headers: []
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
                 body: ""
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
             headers: []
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
  end
end
