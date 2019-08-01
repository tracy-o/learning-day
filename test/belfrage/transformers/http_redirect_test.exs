defmodule Belfrage.Transformers.HTTPredirectTest do
  use ExUnit.Case

  alias Belfrage.Transformers.HTTPredirect
  alias Test.Support.StructHelper

  @http_request_struct StructHelper.build(
                         private: %{origin: "http://www.bbc.co.uk"},
                         request: %{
                           scheme: :http,
                           host: "www.bbc.co.uk",
                           query_params: %{"foo" => "bar"}
                         }
                       )

  @https_request_struct StructHelper.build(
                          private: %{origin: "https://www.bbc.co.uk"},
                          request: %{
                            scheme: :https,
                            query_params: %{"foo" => "bar"}
                          }
                        )

  test "http request will be redirected to https" do
    assert {
             :redirect,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 http_status: 302,
                 headers: %{
                   location: "https://www.bbc.co.uk/_web_core?foo=bar"
                 }
               }
             }
           } = HTTPredirect.call([], @http_request_struct)
  end

  test "https request will not be redirected" do
    assert {
             :ok,
             @https_request_struct
           } = HTTPredirect.call([], @https_request_struct)
  end
end
