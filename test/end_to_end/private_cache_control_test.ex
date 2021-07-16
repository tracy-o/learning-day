defmodule EndToEndTest.PrivateCacheControlTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  use Test.Support.Helper, :mox

  @moduletag :end_to_end

  @lambda_response %{
    "headers" => %{
      "cache-control" => "private, max-age=60"
    },
    "statusCode" => 200,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }

  @lambda_private_error_response %{
    "headers" => %{
      "cache-control" => "private, max-age=123"
    },
    "statusCode" => 500,
    "body" => "<h1>error from the lambda</h1>"
  }

  setup do
    :ets.delete_all_objects(:cache)
    Belfrage.LoopsSupervisor.kill_all()
  end

  test "when cache header is private from lambda origin, stale-while-revalidate is added to cache-control" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _role_arn, _function, _payload, _request_id, _opts ->
      {:ok, @lambda_response}
    end)

    conn = conn(:get, "/200-ok-response")
    conn = Router.call(conn, [])

    assert {200, headers, _body} = sent_resp(conn)
    assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30, max-age=60"} in headers
  end

  test "when belfrage 404s, stale-while-revalidate is added to cache-control" do
    conn = conn(:get, "/this-is-a-404")
    conn = Router.call(conn, [])

    assert {404, headers, _body} = sent_resp(conn)
    assert {"cache-control", "public, stale-if-error=90, stale-while-revalidate=60, max-age=30"} in headers
  end

  test "when Pres 500s with private cache control, Belfrage keeps cache-control as private" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _role_arn, _function, _payload, _request_id, _opts ->
      {:ok, @lambda_private_error_response}
    end)

    conn = conn(:get, "/downstream-broken")
    conn = Router.call(conn, [])

    assert {500, headers, _body} = sent_resp(conn)
    assert {"cache-control", "private, stale-if-error=90, stale-while-revalidate=30, max-age=123"} in headers
  end
end
