defmodule EndToEnd.ProxyOnJoan do
  use ExUnit.Case, async: true
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.RouteState
  alias Belfrage.Clients.HTTPMock
  alias Belfrage.Clients.HTTP
  use Test.Support.Helper, :mox

  @lambda_response %{
    "headers" => %{
      "cache-control" => "public, max-age=30"
    },
    "statusCode" => 200,
    "body" => "<h1>Hello from the Lambda!</h1>"
  }

  @http_response {:ok,
                  %Belfrage.Clients.HTTP.Response{
                    status_code: 200,
                    headers: %{"content-type" => "text/plain"},
                    body: "200 - OK"
                  }}

  setup do
    :ets.delete_all_objects(:cache)
    start_supervised!({RouteState, "SomeRouteState"})
    :ok
  end

  describe "a request with webcore platform on Joan" do
    setup do
      set_stack_id("joan")
      :ok
    end

    test "should change the origin to the mozart news enpoint" do
      url = "https://mozart-news.example.com:test/200-ok-response"
      HTTPMock |> expect(:execute, 1, fn request = %HTTP.Request{url: url}, :Webcore -> @http_response end)

      conn =
        conn(:get, "/200-ok-response")
        |> Router.call([])
    end
  end

  describe "a request with a webcore platform on Bruce" do
    setup do
      set_stack_id("bruce")
      :ok
    end

    test "the origin should stay as the pwa lambda" do
      Belfrage.Clients.LambdaMock
      |> expect(:call, 1, fn _credentials, "pwa-lambda-function:test", _payload, _request_id, _opts ->
        {:ok, @lambda_response}
      end)

      conn =
        conn(:get, "/200-ok-response")
        |> Router.call([])
    end
  end

  def set_stack_id(stack_id) do
    prev_stack_id = Application.get_env(:belfrage, :stack_id)
    Application.put_env(:belfrage, :stack_id, stack_id)

    on_exit(fn -> Application.put_env(:belfrage, :stack_id, prev_stack_id) end)
  end
end
