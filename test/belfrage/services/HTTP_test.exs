defmodule Belfrage.Services.HTTPTest do
  alias Belfrage.Clients
  alias Belfrage.Services.HTTP
  alias Test.Support.StructHelper

  use ExUnit.Case
  use Test.Support.Helper, :mox

  @get_struct StructHelper.build(
                private: %{origin: "https://www.bbc.co.uk"},
                request: %{path: "/_web_core", query_params: %{"foo" => "bar"}}
              )
  @post_struct StructHelper.build(
                 private: %{origin: "https://www.bbc.co.uk"},
                 request: %{payload: ~s({"some": "data"}), method: "POST", query_params: %{"foo" => "bar"}}
               )

  @generic_response {:ok,
                     %Mojito.Response{
                       status_code: 200,
                       headers: [{"content-type", "application/json"}],
                       body: "{}"
                     }}

  describe "HTTP service" do
    test "get returns a response" do
      Clients.HTTPMock
      |> expect(:request, fn :get, "https://www.bbc.co.uk/_web_core?foo=bar" -> @generic_response end)

      HTTP.dispatch(@get_struct)
    end

    test "post returns a response" do
      Clients.HTTPMock
      |> expect(:request, fn :post, "https://www.bbc.co.uk/_web_core?foo=bar", ~s({"some": "data"}) ->
        @generic_response
      end)

      HTTP.dispatch(@post_struct)
    end
  end
end
