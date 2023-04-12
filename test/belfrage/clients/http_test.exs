defmodule Belfrage.Clients.HTTPTest do
  alias Belfrage.Clients.HTTP
  use ExUnit.Case
  use Test.Support.Helper, :mox

  describe "&build_options/2" do
    test "builds options with timeout value and a pool group" do
      assert HTTP.build_options(%HTTP.Request{timeout: 1_000}, :fabl) == %{
               request_timeout: 1_000,
               pool_group: :fabl
             }
    end
  end

  describe "successful requests" do
    test ":post request" do
      FinchMock
      |> expect(:request, fn request, Finch, [receive_timeout: 500, pool_timeout: 5_000] ->
        assert request.method == "POST"

        {:ok,
         %Finch.Response{
           status: 200,
           body: ~s(<p>done something</p>),
           headers: [{"accept-encoding", "application/json"}]
         }}
      end)

      result =
        HTTP.execute(%HTTP.Request{
          method: :post,
          url: "http://example.com/do-something",
          headers: %{"content-length" => "0"},
          timeout: 500,
          payload: ~s({"comment": "Hello"})
        })

      assert result ==
               {:ok,
                %HTTP.Response{
                  status_code: 200,
                  body: ~s(<p>done something</p>),
                  headers: %{"accept-encoding" => "application/json"}
                }}
    end

    test ":get request" do
      FinchMock
      |> expect(:request, fn request, Finch, [receive_timeout: 500, pool_timeout: 5_000] ->
        assert request.method == "GET"

        {:ok, %Finch.Response{status: 200, body: ~s(<p>some content</p>), headers: []}}
      end)

      result =
        HTTP.execute(%HTTP.Request{
          method: :get,
          url: "http://example.com?foo=bar",
          headers: [{"content-length", "0"}],
          timeout: 500
        })

      assert result ==
               {:ok,
                %HTTP.Response{
                  status_code: 200,
                  body: ~s(<p>some content</p>),
                  headers: %{}
                }}
    end
  end

  describe "failed requests" do
    test "no scheme, bad url scheme" do
      assert {:error, %HTTP.Error{reason: :bad_url_scheme}} ==
               HTTP.execute(%HTTP.Request{
                 method: :get,
                 url: "example.com",
                 headers: [{"content-length", "0"}],
                 timeout: 500
               })
    end

    test "invalid scheme, bad url scheme" do
      assert {:error, %HTTP.Error{reason: :bad_url_scheme}} ==
               HTTP.execute(%HTTP.Request{
                 method: :get,
                 url: "ftp://example.com",
                 headers: [{"content-length", "0"}],
                 timeout: 500
               })
    end

    test "bad url scheme" do
      assert {:error, %HTTP.Error{reason: :bad_url_scheme}} ==
               HTTP.execute(%HTTP.Request{
                 method: :get,
                 url: "example.com",
                 headers: [{"content-length", "0"}],
                 timeout: 500
               })
    end

    test "pool timeout" do
      FinchMock
      |> expect(:request, fn _request, Finch, _opts ->
        exit({:timeout, {NimblePool, :checkout, [:pids]}})
      end)

      assert {:error, %HTTP.Error{reason: :pool_timeout}} ==
               HTTP.execute(%HTTP.Request{
                 method: :get,
                 url: "http://example.com?foo=bar",
                 headers: [{"content-length", "0"}],
                 timeout: 500
               })
    end

    test "request timeout" do
      FinchMock
      |> expect(:request, fn _request, Finch, _opts ->
        {:error, %Mint.TransportError{reason: :timeout}}
      end)

      assert {:error, %HTTP.Error{reason: :timeout}} ==
               HTTP.execute(%HTTP.Request{
                 method: :get,
                 url: "http://example.com?foo=bar",
                 headers: [{"content-length", "0"}],
                 timeout: 500
               })
    end

    test "unexpected format of error reason" do
      FinchMock
      |> expect(:request, fn _request, Finch, _opts ->
        {:error, %Mint.TransportError{reason: {:error, "unexpected format"}}}
      end)

      assert {:error, %HTTP.Error{reason: nil}} ==
               HTTP.execute(%HTTP.Request{
                 method: :get,
                 url: "http://example.com",
                 headers: [{"content-length", "0"}],
                 timeout: 500
               })
    end

    test "unexpected error reason" do
      FinchMock
      |> expect(:request, fn _request, _finch, _opts ->
        {:error, %Mint.TransportError{reason: "something broke"}}
      end)

      assert {:error, %HTTP.Error{reason: nil}} ==
               HTTP.execute(%HTTP.Request{
                 method: :get,
                 url: "http://example.com",
                 headers: [{"content-length", "0"}],
                 timeout: 500
               })
    end
  end
end
