defmodule Belfrage.Transformers.HTTPredirectTest do
  use ExUnit.Case

  alias Belfrage.Transformers.HTTPredirect
  alias Test.Support.StructHelper

  @http_request_struct StructHelper.build(
                         private: %{origin: "http://www.bbc.co.uk"},
                         request: %{
                           scheme: :http,
                           host: "www.bbc.co.uk",
                           query_params: %{}
                         }
                       )

  @https_request_struct StructHelper.build(
                          private: %{origin: "https://www.bbc.co.uk"},
                          request: %{
                            scheme: :https,
                            query_params: %{}
                          }
                        )

  @http_request_struct_with_qs StructHelper.build(
                                 private: %{origin: "http://www.bbc.co.uk"},
                                 request: %{
                                   scheme: :http,
                                   host: "www.bbc.co.uk",
                                   query_params: %{"foo" => "bar"}
                                 }
                               )

  @https_request_struct_with_qs StructHelper.build(
                                  private: %{origin: "https://www.bbc.co.uk"},
                                  request: %{
                                    scheme: :https,
                                    query_params: %{"foo" => "bar"}
                                  }
                                )

  test "http request without a query string will be redirected to https" do
    assert {
             :redirect,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 http_status: 302,
                 body: "Redirecting",
                 headers: %{
                   "location" => "https://www.bbc.co.uk/_web_core",
                   "X-BBC-No-Scheme-Rewrite" => "1"
                 }
               }
             }
           } = HTTPredirect.call([], @http_request_struct)
  end

  test "https request without a query string will not be redirected" do
    assert {
             :ok,
             @https_request_struct
           } = HTTPredirect.call([], @https_request_struct)
  end

  test "http request with a query string will be redirected to https" do
    assert {
             :redirect,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 http_status: 302,
                 body: "Redirecting",
                 headers: %{
                   "location" => "https://www.bbc.co.uk/_web_core?foo=bar",
                   "X-BBC-No-Scheme-Rewrite" => "1"
                 }
               }
             }
           } = HTTPredirect.call([], @http_request_struct_with_qs)
  end

  test "https request with a query string will not be redirected" do
    assert {
             :ok,
             @https_request_struct
           } = HTTPredirect.call([], @https_request_struct_with_qs)
  end
end
