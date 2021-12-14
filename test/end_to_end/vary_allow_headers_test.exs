defmodule EndToEnd.VaryAllowHeadersTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper

  alias BelfrageWeb.Router
  alias Routes.Specs.SomeLoopAllowHeaders

  @lambda_response %{
    "headers" => %{
      "cache-control" => "public, max-age=30"
    },
    "statusCode" => 200,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }

  @moduletag :end_to_end

  setup do
    Belfrage.Clients.LambdaMock
    |> stub(:call, fn _lambda_name, _role_arn, _headers, _request_id, _opts ->
      {:ok, @lambda_response}
    end)

    on_exit(&clear_cache/0)
  end

  describe "when route allows headers" do
    test "vary header contains allow headers" do
      headers_allowlist = SomeLoopAllowHeaders.specs().headers_allowlist -- ["cookie"]

      [vary_header] = conn(:get, "/route-allow-headers") |> Router.call([]) |> get_resp_header("vary")
      assert vary_header =~ ",#{headers_allowlist |> Enum.join(",")}"
    end

    test "vary header does not contain cookie" do
      [vary_header] = conn(:get, "/route-allow-headers") |> Router.call([]) |> get_resp_header("vary")
      refute vary_header =~ ",cookie"
    end

    test "request hash varies on allow headers of different values" do
      headers_allowlist = SomeLoopAllowHeaders.specs().headers_allowlist -- ["cookie"]

      for allow_header <- headers_allowlist do
        [request_hash1] =
          conn(:get, "/route-allow-headers")
          |> put_req_header(allow_header, "foo")
          |> Router.call([])
          |> get_resp_header("bsig")

        [request_hash2] =
          conn(:get, "/route-allow-headers")
          |> put_req_header(allow_header, "bar")
          |> Router.call([])
          |> get_resp_header("bsig")

        assert request_hash1 != request_hash2
      end
    end

    test "request hash does not vary on allow headers of the same value" do
      headers_allowlist = SomeLoopAllowHeaders.specs().headers_allowlist -- ["cookie"]

      for allow_header <- headers_allowlist do
        [request_hash1] =
          conn(:get, "/route-allow-headers")
          |> put_req_header(allow_header, "the_same_foo")
          |> Router.call([])
          |> get_resp_header("bsig")

        [request_hash2] =
          conn(:get, "/route-allow-headers")
          |> put_req_header(allow_header, "the_same_foo")
          |> Router.call([])
          |> get_resp_header("bsig")

        assert request_hash1 == request_hash2
      end
    end

    test "request hash does not vary on cookie" do
      [request_hash1] =
        conn(:get, "/route-allow-headers")
        |> put_req_header("cookie", "foo")
        |> Router.call([])
        |> get_resp_header("bsig")

      [request_hash2] =
        conn(:get, "/route-allow-headers")
        |> put_req_header("cookie", "bar")
        |> Router.call([])
        |> get_resp_header("bsig")

      assert request_hash1 == request_hash2
    end
  end
end
