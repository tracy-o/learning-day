defmodule Belfrage.Transformers.WorldServiceRedirectTest do
  use ExUnit.Case

  alias Belfrage.Transformers.WorldServiceRedirect
  alias Belfrage.Struct

  @http_uk_request_struct %Struct{
    private: %Struct.Private{origin: "http://www.bbc.co.uk"},
    request: %Struct.Request{
      scheme: :http,
      host: "www.bbc.co.uk",
      path: "/_web_core"
    }
  }

  @http_com_request_struct %Struct{
    private: %Struct.Private{origin: "http://www.bbc.com"},
    request: %Struct.Request{
      host: "www.bbc.com",
      path: "/_web_core",
      scheme: :http
    }
  }

  test ".co.uk http request will be uplifted to http and redirected to .com" do
    assert {
             :redirect,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 http_status: 302,
                 body: "Redirecting",
                 headers: %{
                   "location" => "https://www.bbc.com/_web_core",
                   "X-BBC-No-Scheme-Rewrite" => "1"
                 }
               }
             }
           } = WorldServiceRedirect.call([], @http_uk_request_struct)
  end

  test ".com http request will still be uplifted to https" do
    assert {
             :redirect,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 http_status: 302,
                 body: "Redirecting",
                 headers: %{
                   "location" => "https://www.bbc.com/_web_core",
                   "X-BBC-No-Scheme-Rewrite" => "1"
                 }
               }
             }
           } = WorldServiceRedirect.call([], @http_com_request_struct)
  end
end
