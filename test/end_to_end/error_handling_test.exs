defmodule EndToEnd.ErrorHandlingTest do
  use ExUnit.Case
  use Plug.Test
  use Test.Support.Helper, :mox
  import Belfrage.Test.CachingHelper

  alias BelfrageWeb.Router
  alias Belfrage.Clients.LambdaMock

  @moduletag :end_to_end

  setup :clear_cache

  test "exception in Belfrage results in a 500" do
    {status, _headers, body} = make_call()
    assert status == 500
    assert body == "<h1>500 Internal Server Error</h1>\n<!-- Belfrage -->"
  end

  def make_call() do
    # For simplicity make LambdaMock raise an exception, but it could be an
    # exception in any code executed during the request lifecycle
    stub(LambdaMock, :call, fn _role_arn, _function_arn, _request, _opts ->
      raise "Boom"
    end)

    conn = conn(:get, "/200-ok-response")

    assert_raise Plug.Conn.WrapperError, "** (RuntimeError) Boom", fn ->
      Router.call(conn, routefile: Routes.Routefiles.Mock)
    end

    sent_resp(conn)
  end
end
