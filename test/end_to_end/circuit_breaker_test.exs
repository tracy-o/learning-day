defmodule EndToEnd.CircuitBreakerTest do
  use ExUnit.Case
  use Plug.Test
  alias Belfrage.RouteState
  import Belfrage.Test.StubHelper
  import Belfrage.Test.CachingHelper
  use Test.Support.Helper, :mox

  @lambda_response %{
    "headers" => %{
      "cache-control" => "public, max-age=30"
    },
    "statusCode" => 200,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }

  test "when the circuit breaker dial is set to false, the next throughtput is 100 and corresponding requests are not circuit broken" do
    clear_cache()
    stub_dials(circuit_breaker: "false")
    pid = start_supervised!({RouteState, {{"CacheDisabled", "Webcore"}, %{}}})

    expect(Belfrage.Clients.LambdaMock, :call, fn _credentials, _lambda_arn, _body, _opts ->
      {:ok, @lambda_response}
    end)

    :sys.replace_state(pid, fn state ->
      Map.merge(state, %{
        circuit_breaker_error_threshold: 10,
        counter: %{
          "pwa-lambda-function" => %{
            500 => 20,
            :errors => 20
          }
        },
        origin: "pwa-lambda-function",
        throughput: 100
      })
    end)

    Process.send_after(pid, :reset, 0)

    Process.sleep(100)

    assert :sys.get_state(pid)[:throughput] == 100

    conn =
      :get
      |> conn("/caching-disabled")
      |> BelfrageWeb.Router.call([])

    assert conn.status == 200
  end

  test "when the circuit breaker dial is set to true, the next throughtput is 0 and corresponding requests are circuit broken" do
    clear_cache()
    stub_dials(circuit_breaker: "true")
    pid = start_supervised!({RouteState, {{"CacheDisabled", "Webcore"}, %{}}})

    :sys.replace_state(pid, fn state ->
      Map.merge(state, %{
        circuit_breaker_error_threshold: 10,
        counter: %{
          "pwa-lambda-function" => %{
            500 => 20,
            :errors => 20
          }
        },
        origin: "pwa-lambda-function",
        throughput: 100
      })
    end)

    Process.send_after(pid, :reset, 0)

    Process.sleep(100)

    assert :sys.get_state(pid)[:throughput] == 0

    conn =
      :get
      |> conn("/caching-disabled")
      |> BelfrageWeb.Router.call([])

    assert conn.status == 500
  end
end
