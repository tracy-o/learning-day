defmodule EndToEnd.GamesInternationalRedirectTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  alias BelfrageWeb.Router

  @moduletag :end_to_end

  @lambda_response %{
    "headers" => %{
      "cache-control" => "public, max-age=30"
    },
    "statusCode" => 200,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }

  setup do
    :ets.delete_all_objects(:cache)
    :ok
  end

  describe "redirect to bbcchannels.com" do
    test "bbc.com/games redirects to bbcchannels.com when x-ip_is_uk_combined is set to no" do
      response_conn =
        conn(:get, "https://www.bbc.com/games")
        |> put_req_header("x-ip_is_uk_combined", "no")
        |> Router.call(routefile: Routes.Routefiles.Main.Test)

      assert {301, headers, ""} = sent_resp(response_conn)
      assert {"location", "https://www.bbcchannels.com"} in headers

      assert {"vary",
              "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"} in headers
    end

    test "bbc.com/games redirects to bbcchannels.com when x-ip_is_uk_combined not set" do
      response_conn =
        conn(:get, "https://www.bbc.com/games")
        |> Router.call(routefile: Routes.Routefiles.Main.Test)

      assert {301, headers, ""} = sent_resp(response_conn)
      assert {"location", "https://www.bbcchannels.com"} in headers

      assert {"vary",
              "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"} in headers
    end
  end

  describe "no redirect to bbcchannels.com" do
    test "bbc.com/games does not redirect to bbcchannels.com when x-ip_is_uk_combined is set to yes" do
      Belfrage.Clients.LambdaMock
      |> expect(:call, fn _credentials, _lambda_arn, _request, _opts ->
        {:ok, @lambda_response}
      end)

      response_conn =
        conn(:get, "https://www.bbc.com/games")
        |> put_req_header("x-ip_is_uk_combined", "yes")
        |> Router.call(routefile: Routes.Routefiles.Main.Test)

      assert {200, headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(response_conn)

      assert {"vary",
              "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"} in headers
    end

    test "bbc.co.uk/games does not redirect to bbcchannels.com when x-ip_is_uk_combined is set to no" do
      Belfrage.Clients.LambdaMock
      |> expect(:call, fn _credentials, _lambda_arn, _request, _opts ->
        {:ok, @lambda_response}
      end)

      response_conn =
        conn(:get, "https://www.bbc.co.uk/games")
        |> put_req_header("x-ip_is_uk_combined", "no")
        |> Router.call(routefile: Routes.Routefiles.Main.Test)

      assert {200, headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(response_conn)

      assert {"vary",
              "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"} in headers
    end

    test "bbc.co.uk/games does not redirect to bbcchannels.com when x-ip_is_uk_combined is not set" do
      Belfrage.Clients.LambdaMock
      |> expect(:call, fn _credentials, _lambda_arn, _request, _opts ->
        {:ok, @lambda_response}
      end)

      response_conn =
        conn(:get, "https://www.bbc.co.uk/games")
        |> Router.call(routefile: Routes.Routefiles.Main.Test)

      assert {200, headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(response_conn)

      assert {"vary",
              "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme,cookie-ckns_bbccom_beta"} in headers
    end
  end
end
