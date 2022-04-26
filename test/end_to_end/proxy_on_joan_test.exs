defmodule EndToEnd.ProxyOnJoan do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.Clients.HTTPMock
  alias Belfrage.Clients.HTTP
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [set_stack_id: 1]

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
    :ok
  end

  describe "a NewsArticlesPage request on Joan" do
    setup do
      set_stack_id("joan")
      :ok
    end

    test "should change the origin to the mozart news endpoint" do
      url = "https://mozart-news.example.com:test/proxy-on-joan/49336140"
      HTTPMock |> expect(:execute, 1, fn %HTTP.Request{url: ^url}, _pool -> @http_response end)

      conn(:get, "/proxy-on-joan/49336140")
      |> Router.call([])
    end
  end

  describe "a NewsArticlesPage request on Bruce" do
    setup do
      set_stack_id("bruce")
      :ok
    end

    test "the origin should stay as the pwa lambda" do
      Belfrage.Clients.LambdaMock
      |> expect(:call, 1, fn _credentials, "pwa-lambda-function:test", _payload, _request_id, _opts ->
        {:ok, @lambda_response}
      end)

      conn(:get, "/proxy-on-joan/49336140")
      |> Router.call([])
    end
  end
end
