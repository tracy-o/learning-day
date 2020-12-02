defmodule EndToEndTest.ComToUKRedirectTest do
  use ExUnit.Case, async: false
  use Plug.Test
  use Test.Support.Helper, :mox

  alias BelfrageWeb.Router

  @moduletag :end_to_end

  test "redirect to .co.uk when host is .com" do
    conn =
      conn(:get, "/com-to-uk-redirect")
      |> put_req_header("x-bbc-edge-host", "www.test.bbc.com")
      |> Router.call([])

    assert {302, headers, "Redirecting"} = sent_resp(conn)
    assert {"location", "https://www.test.bbc.co.uk/com-to-uk-redirect"} in headers
    assert {"cache-control", "public, stale-if-error=90, stale-while-revalidate=10, max-age=60"} in headers
  end

  test "redirect to .co.uk with correct query params" do
    conn =
      conn(:get, "/com-to-uk-redirect?q=ruby&page=3&not_allowed=bar")
      |> put_req_header("x-bbc-edge-host", "www.test.bbc.com")
      |> Router.call([])

    assert {302, headers, "Redirecting"} = sent_resp(conn)
    assert {"location", "https://www.test.bbc.co.uk/com-to-uk-redirect?page=3&q=ruby"} in headers
    assert {"cache-control", "public, stale-if-error=90, stale-while-revalidate=10, max-age=60"} in headers
  end

  test "does not redirect and call origin when host is not .com" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _lambda_name, _role_arn, _headers, _opts ->
      {:ok,
       %{
         "headers" => %{"cache-control" => "public, max-age=60"},
         "statusCode" => 200,
         "body" => "<h1>Hello from the Lambda!</h1>"
       }}
    end)

    conn =
      conn(:get, "/com-to-uk-redirect?q=ruby&page=3&not_allowed=bar")
      |> put_req_header("x-bbc-edge-host", "www.test.bbc.co.uk")
      |> Router.call([])

    assert {200, headers, "<h1>Hello from the Lambda!</h1>"} = sent_resp(conn)
    assert {"cache-control", "public, stale-if-error=90, stale-while-revalidate=30, max-age=60"} in headers
  end
end
