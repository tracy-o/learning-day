defmodule Belfrage.AWS.HttpClientTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.AWS.HttpClient
  alias Belfrage.Clients.HTTP.Request
  alias Belfrage.Clients.HTTPMock

  @default_timeout Application.get_env(:belfrage, :default_timeout)

  describe "request/5" do
    test "GET request" do
      expected_request = %Request{
        method: :get,
        url: "https://www.example.com/foo?some-qs=hello",
        payload: "",
        headers: %{"some" => "header"},
        timeout: @default_timeout
      }

      expect(HTTPMock, :execute, fn ^expected_request, :AWS -> :ok end)
      assert HttpClient.request(:get, "https://www.example.com/foo?some-qs=hello", "", [{"some", "header"}]) == :ok
    end

    test "POST request" do
      expected_request = %Request{
        method: :post,
        url: "https://www.example.com/foo",
        payload: ~s({"some": "data"}),
        headers: %{"some" => "header"},
        timeout: @default_timeout
      }

      expect(HTTPMock, :execute, fn ^expected_request, :AWS -> :ok end)
      assert HttpClient.request(:post, "https://www.example.com/foo", ~s({"some": "data"}), [{"some", "header"}]) == :ok
    end

    test "http options" do
      expected_request = %Request{
        method: :get,
        url: "https://www.example.com",
        payload: "",
        headers: %{},
        timeout: 123
      }

      expect(HTTPMock, :execute, fn ^expected_request, :SomePool -> :ok end)
      assert HttpClient.request(:get, "https://www.example.com", "", [], timeout: 123, pool_name: :SomePool) == :ok
    end
  end
end
