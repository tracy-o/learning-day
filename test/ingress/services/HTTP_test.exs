defmodule Ingress.Services.HTTPTest do
  alias Ingress.Services.HTTPClientMock
  alias Ingress.Services.HTTP
  alias Test.Support.StructHelper

  use ExUnit.Case
  use Test.Support.Helper, :mox

  @get_struct StructHelper.build(private: %{origin: "https://www.bbc.co.uk"})
  @post_struct StructHelper.build(
                 private: %{origin: "https://www.bbc.co.uk"},
                 request: %{payload: ~s({"some": "data"}), method: "POST"}
               )

  @generic_response {:ok,
                     %HTTPoison.Response{
                       status_code: 200,
                       headers: [{"content-type", "application/json"}],
                       body: "{}"
                     }}

  describe "HTTP service" do
    test "get returns a response" do
      HTTPClientMock
      |> expect(:get, fn "https://www.bbc.co.uk", "/_web_core" -> @generic_response end)

      HTTP.dispatch(@get_struct)
    end

    test "post returns a response" do
      HTTPClientMock
      |> expect(:post, fn "https://www.bbc.co.uk", "/_web_core", ~s({"some": "data"}) ->
        @generic_response
      end)

      HTTP.dispatch(@post_struct)
    end
  end
end
