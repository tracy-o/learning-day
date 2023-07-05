defmodule Belfrage.Services.BBCXTest do
  alias Belfrage.Clients
  alias Belfrage.Services.BBCX
  alias Belfrage.Envelope

  use ExUnit.Case
  use Test.Support.Helper, :mox

  @get_envelope %Envelope{
    private: %Envelope.Private{
      origin: "https://web.test.bbcx-internal.com",
      platform: "BBCX"
    },
    request: %Envelope.Request{
      method: "GET",
      path: "/news/articles/crgm198rvgdo",
      country: "us",
      host: "www.bbc.com",
      query_params: %{
        "foo" => "bar"
      },
      req_svc_chain: "BELFRAGE"
    }
  }

  defmacro expect_request(request, response) do
    quote do
      expect(Clients.HTTPMock, :execute, fn unquote(request), _ -> unquote(response) end)
    end
  end

  describe "HTTP service" do
    test "origin returns a 200 response" do
      ok_response = {
        :ok,
        %Clients.HTTP.Response{
          status_code: 200,
          headers: %{"content-type" => "text/html; charset=utf-8"},
          body: "Some BBCX content"
        }
      }

      expect_request(
        %Clients.HTTP.Request{
          method: :get,
          url: "https://web.test.bbcx-internal.com/news/articles/crgm198rvgdo?foo=bar",
          headers: %{
            "accept-encoding" => "gzip",
            "country" => "us",
            "user-agent" => "Belfrage",
            "req-svc-chain" => "BELFRAGE"
          }
        },
        ok_response
      )

      assert %Envelope{
               response: %Envelope.Response{
                 http_status: 200,
                 body: "Some BBCX content",
                 headers: %{"content-type" => "text/html; charset=utf-8"}
               }
             } = BBCX.dispatch(@get_envelope)
    end

    test "origin returns a 500 response" do
      ko_response =
        {:ok,
         %Clients.HTTP.Response{
           status_code: 500,
           headers: %{"content-type" => "text/html; charset=utf-8"},
           body: "500 - Internal Server Error"
         }}

      expect_request(
        %Clients.HTTP.Request{
          method: :get,
          url: "https://web.test.bbcx-internal.com/news/articles/crgm198rvgdo?foo=bar",
          headers: %{
            "accept-encoding" => "gzip",
            "country" => "us",
            "user-agent" => "Belfrage",
            "req-svc-chain" => "BELFRAGE"
          }
        },
        ko_response
      )

      assert %Envelope{
               response: %Envelope.Response{
                 http_status: 500,
                 body: "500 - Internal Server Error"
               }
             } = BBCX.dispatch(@get_envelope)
    end

    test "Cannot connect to origin" do
      ko_response = {:error, %Clients.HTTP.Error{reason: :failed_to_connect}}

      expect_request(
        %Clients.HTTP.Request{
          method: :get,
          url: "https://web.test.bbcx-internal.com/news/articles/crgm198rvgdo?foo=bar",
          headers: %{
            "accept-encoding" => "gzip",
            "country" => "us",
            "user-agent" => "Belfrage",
            "req-svc-chain" => "BELFRAGE"
          }
        },
        ko_response
      )

      assert %Envelope{
               response: %Envelope.Response{
                 http_status: 500,
                 body: "",
                 headers: %{}
               }
             } = BBCX.dispatch(@get_envelope)
    end
  end
end
