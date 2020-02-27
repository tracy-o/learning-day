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
      Belfrage.Clients.HTTP.MachineGunMock
      |> expect(:request, fn :post,
                             "http://example.com/do-something",
                             ~s({"comment": "Hello"}),
                             [{"content-length", "0"}],
                             %{request_timeout: 500} ->
        {:ok,
         %MachineGun.Response{
           status_code: 200,
           body: ~s(<p>done something</p>),
           headers: %{"accept-encoding" => "application/json"}
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
      Belfrage.Clients.HTTP.MachineGunMock
      |> expect(:request, fn :get,
                             "http://example.com?foo=bar",
                             "",
                             [{"content-length", "0"}],
                             %{request_timeout: 500} ->
        {:ok, %MachineGun.Response{status_code: 200, body: ~s(<p>some content</p>), headers: []}}
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
    test "bad url scheme" do
      Belfrage.Clients.HTTP.MachineGunMock
      |> expect(:request, fn _method, _url, _payload, _headers, _opts ->
        {:error, %MachineGun.Error{reason: :bad_url_scheme}}
      end)

      assert {:error, %HTTP.Error{reason: :bad_url_scheme}} ==
               HTTP.execute(%HTTP.Request{
                 method: :get,
                 url: "example.com",
                 headers: [{"content-length", "0"}],
                 timeout: 500
               })
    end

    test "bad url" do
      Belfrage.Clients.HTTP.MachineGunMock
      |> expect(:request, fn _method, _url, _payload, _headers, _opts ->
        {:error, %MachineGun.Error{reason: :bad_url}}
      end)

      assert {:error, %HTTP.Error{reason: :bad_url}} ==
               HTTP.execute(%HTTP.Request{
                 method: :get,
                 url: "http://@($%£*$%£$*HF£$HF*£$F",
                 headers: [{"content-length", "0"}],
                 timeout: 500
               })
    end

    test "pool timeout" do
      Belfrage.Clients.HTTP.MachineGunMock
      |> expect(:request, fn _method, _url, _payload, _headers, _opts ->
        {:error, %MachineGun.Error{reason: :pool_timeout}}
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
      Belfrage.Clients.HTTP.MachineGunMock
      |> expect(:request, fn _method, _url, _payload, _headers, _opts ->
        {:error, %MachineGun.Error{reason: :request_timeout}}
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
      Belfrage.Clients.HTTP.MachineGunMock
      |> expect(:request, fn _method, _url, _payload, _headers, _opts ->
        {:error, %MachineGun.Error{reason: %{error: "Oh no, this isn't good"}}}
      end)

      assert {:error, %HTTP.Error{reason: nil}} ==
               HTTP.execute(%HTTP.Request{
                 method: :get,
                 url: "example.com",
                 headers: [{"content-length", "0"}],
                 timeout: 500
               })
    end

    test "unexpected error reason" do
      Belfrage.Clients.HTTP.MachineGunMock
      |> expect(:request, fn _method, _url, _payload, _headers, _opts ->
        {:error, %MachineGun.Error{reason: :something_broke}}
      end)

      assert {:error, %HTTP.Error{reason: nil}} ==
               HTTP.execute(%HTTP.Request{
                 method: :get,
                 url: "example.com",
                 headers: [{"content-length", "0"}],
                 timeout: 500
               })
    end
  end
end
