defmodule IsCommercialTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.Clients.{HTTPMock, LambdaMock, HTTP.Response, HTTP.Request}
  use Test.Support.Helper, :mox

  import Test.Support.Helper, only: [set_environment: 1]

  @moduletag :end_to_end

  @successful_lambda_response {:ok, %{"statusCode" => 200, "headers" => %{}, "body" => "OK"}}
  @successful_http_response {:ok, %Response{status_code: 200, headers: %{"content-type" => "text/html"}, body: "OK"}}

  describe "when platform is Webcore" do
    test "sends the is_commercial header if potential bbcx content" do
      set_environment("test")
      stub_dial(:bbcxenabled, "true")

      LambdaMock
      |> expect(:call, fn _lambda_name,
                          _role_arn,
                          %{
                            headers: %{"is_commercial" => "true"}
                          },
                          _opts ->
        @successful_lambda_response
      end)

      conn =
        conn(:get, "/some-webcore-bbcx-content")
        |> put_req_header("cookie-ckns_bbccom_beta", "1")
        |> put_req_header("x-bbc-edge-host", "www.bbc.com")
        |> put_req_header("x-country", "ca")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, _response_body} = sent_resp(conn)
    end

    test "does not send the is_commercial header if not a potential bbcx content" do
      set_environment("test")
      stub_dial(:bbcxenabled, "false")

      LambdaMock
      |> expect(:call, fn _lambda_name,
                          _role_arn,
                          %{
                            headers: %{}
                          },
                          _opts ->
        @successful_lambda_response
      end)

      conn =
        conn(:get, "/some-webcore-bbcx-content")
        |> put_req_header("cookie-ckns_bbccom_beta", "0")
        |> put_req_header("x-bbc-edge-host", "www.bbc.com")
        |> put_req_header("x-country", "br")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, _response_body} = sent_resp(conn)
    end
  end

  describe "when platform is MozartNews" do
    test "sends the is_commercial header if potential bbcx content" do
      set_environment("test")
      stub_dial(:bbcxenabled, "true")

      HTTPMock
      |> expect(:execute, fn %Request{headers: headers}, :MozartNews ->
        assert Map.has_key?(headers, "is_commercial")
        assert String.contains?(headers["is_commercial"], "true")

        @successful_http_response
      end)

      conn =
        conn(:get, "/some-mozart-bbcx-content")
        |> put_req_header("cookie-ckns_bbccom_beta", "1")
        |> put_req_header("x-bbc-edge-host", "www.bbc.com")
        |> put_req_header("x-country", "ca")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, _response_body} = sent_resp(conn)
    end

    test "does not send the is_commercial header if not a potential bbcx content" do
      set_environment("test")
      stub_dial(:bbcxenabled, "false")

      HTTPMock
      |> expect(:execute, fn %Request{headers: headers}, :MozartNews ->
        refute Map.has_key?(headers, "is_commercial")

        @successful_http_response
      end)

      conn =
        conn(:get, "/some-mozart-bbcx-content")
        |> put_req_header("cookie-ckns_bbccom_beta", "0")
        |> put_req_header("x-bbc-edge-host", "www.bbc.com")
        |> put_req_header("x-country", "br")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, _response_body} = sent_resp(conn)
    end
  end

  describe "when platform is MozartSport" do
    test "sends the is_commercial header if potential bbcx content" do
      set_environment("test")
      stub_dial(:bbcxenabled, "true")

      HTTPMock
      |> expect(:execute, fn %Request{headers: headers}, :MozartSport ->
        assert Map.has_key?(headers, "is_commercial")
        assert String.contains?(headers["is_commercial"], "true")

        @successful_http_response
      end)

      conn =
        conn(:get, "/some-mozart-sport-bbcx-content")
        |> put_req_header("cookie-ckns_bbccom_beta", "1")
        |> put_req_header("x-bbc-edge-host", "www.bbc.com")
        |> put_req_header("x-country", "ca")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, _response_body} = sent_resp(conn)
    end

    test "does not send the is_commercial header if not a potential bbcx content" do
      set_environment("test")
      stub_dial(:bbcxenabled, "false")

      HTTPMock
      |> expect(:execute, fn %Request{headers: headers}, :MozartSport ->
        refute Map.has_key?(headers, "is_commercial")

        @successful_http_response
      end)

      conn =
        conn(:get, "/some-mozart-sport-bbcx-content")
        |> put_req_header("cookie-ckns_bbccom_beta", "0")
        |> put_req_header("x-bbc-edge-host", "www.bbc.com")
        |> put_req_header("x-country", "br")
        |> Router.call(routefile: Routes.Routefiles.Mock)

      assert {200, _headers, _response_body} = sent_resp(conn)
    end
  end
end
