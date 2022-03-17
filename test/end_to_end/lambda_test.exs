defmodule EndToEnd.LambdaTest do
  use ExUnit.Case
  use Plug.Test
  alias BelfrageWeb.Router
  alias Belfrage.RouteState
  use Test.Support.Helper, :mox

  import Test.Support.Helper, only: [assert_valid_request_hash: 1]

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
    start_supervised!({RouteState, "SomeRouteState"})
    :ok
  end

  test "a successful response from a lambda e2e" do
    credentials = Belfrage.Services.Webcore.Credentials.get()
    lambda_arn = Application.get_env(:belfrage, :pwa_lambda_function) <> ":test"

    Belfrage.Clients.LambdaMock
    |> expect(:call, fn ^credentials,
                        ^lambda_arn,
                        %{
                          body: "",
                          headers: %{
                            "accept-encoding": "gzip",
                            country: "gb",
                            host: "www.example.com",
                            is_uk: false,
                            language: "en-GB"
                          },
                          httpMethod: "GET",
                          path: "/200-ok-response",
                          pathParameters: %{},
                          queryStringParameters: %{}
                        },
                        _request_id,
                        _opts ->
      {:ok, @lambda_response}
    end)

    conn = conn(:get, "/200-ok-response")
    conn = Router.call(conn, [])

    assert {200,
            [
              {"cache-control", "public, stale-if-error=90, stale-while-revalidate=30, max-age=30"},
              {"vary", "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme"},
              {"server", "Belfrage"},
              {"bsig", request_hash},
              {"bid", "local"},
              {"via", "1.1 Belfrage"},
              {"req-svc-chain", "BELFRAGE"},
              {"brequestid", _request_id},
              {"belfrage-cache-status", "MISS"},
              {"routespec", "SomeRouteState"},
              {"belfrage-pipeline-trail",
               "DevelopmentRequests,CircuitBreaker,Chameleon,PlatformKillSwitch,Language,LambdaOriginAlias,Personalisation,ProxyOnJoan,TrailingSlashRedirector,HTTPredirect"}
            ], response_body} = sent_resp(conn)

    assert response_body == @lambda_response["body"]
    assert_valid_request_hash(request_hash)
  end

  test "passes on query string parameters" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _role_arn,
                        _function_name,
                        %{
                          queryStringParameters: %{"query" => %{"hi" => "foo"}}
                        },
                        _request_id,
                        _opts ->
      {:ok, @lambda_response}
    end)

    conn = conn(:get, "/200-ok-response?query[hi]=foo")
    Router.call(conn, [])
  end

  test "a failed response from a lambda e2e" do
    Belfrage.Clients.LambdaMock
    |> expect(:call, fn _role_arn, _function_name, _payload, _request_id, _opts ->
      response =
        @lambda_response
        |> Map.put("statusCode", 500)

      {:ok, response}
    end)

    conn = conn(:get, "/downstream-broken")
    conn = Router.call(conn, [])

    assert {500,
            [
              {"cache-control", "public, stale-if-error=90, stale-while-revalidate=30, max-age=30"},
              {"vary", "Accept-Encoding,X-BBC-Edge-Cache,X-Country,X-IP_Is_UK_Combined,X-BBC-Edge-Scheme"},
              {"server", "Belfrage"},
              {"bsig", request_hash},
              {"bid", "local"},
              {"via", "1.1 Belfrage"},
              {"req-svc-chain", "BELFRAGE"},
              {"brequestid", _request_id},
              {"belfrage-cache-status", "MISS"},
              {"routespec", "SomeRouteState"},
              {"belfrage-pipeline-trail",
               "DevelopmentRequests,CircuitBreaker,Chameleon,PlatformKillSwitch,Language,LambdaOriginAlias,Personalisation,ProxyOnJoan,TrailingSlashRedirector,HTTPredirect"}
            ], response_body} = sent_resp(conn)

    assert @lambda_response["body"] == response_body
    assert_valid_request_hash(request_hash)
  end
end
