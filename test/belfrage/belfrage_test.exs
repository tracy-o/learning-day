defmodule BelfrageTest do
  use ExUnit.Case, async: true
  use Plug.Test
  use Test.Support.Helper, :mox

  alias Belfrage.Clients.LambdaMock
  alias Belfrage.Struct

  import Test.Support.Helper, only: [assert_gzipped: 2]

  @get_request_struct %Struct{
    private: %Struct.Private{
      loop_id: "SportVideos",
      production_environment: "test"
    },
    request: %Struct.Request{
      path: "/_web_core",
      method: "GET",
      country: "gb",
      request_id: "gerald-the-get-request"
    }
  }

  @post_request_struct %Struct{
    request: %Struct.Request{
      path: "/",
      method: "POST",
      payload: ~s({"some": "data please"}),
      country: "gb",
      request_id: "pete-the-post-request"
    },
    private: %Struct.Private{
      loop_id: "SportVideos",
      production_environment: "test"
    }
  }

  @web_core_lambda_response {:ok, %{"body" => "Some content", "headers" => %{}, "statusCode" => 200}}
  @web_core_404_lambda_response {:ok, %{"body" => "404 - not found", "headers" => %{}, "statusCode" => 404}}

  test "GET request invokes lambda service with Lambda transformer" do
    LambdaMock
    |> expect(:call, fn _role_arn = "webcore-lambda-role-arn",
                        _lambda_func = "pwa-lambda-function:test",
                        _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                        _request_id = "gerald-the-get-request",
                        _opts = [] ->
      @web_core_lambda_response
    end)

    Belfrage.handle(@get_request_struct)
  end

  test "GET request on a subdomain and preview_mode, invokes lambda with the lambda alias" do
    struct = Belfrage.Struct.add(@get_request_struct, :request, %{subdomain: "example-branch"})
    struct = Belfrage.Struct.add(struct, :private, %{preview_mode: "on"})

    LambdaMock
    |> expect(:call, fn _role_arn = "webcore-lambda-role-arn",
                        _lambda_func = "pwa-lambda-function:example-branch",
                        _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                        _request_id = "gerald-the-get-request",
                        _opts = [] ->
      @web_core_lambda_response
    end)

    Belfrage.handle(struct)
  end

  test "GET request on a subdomain and preview_mode with no matching alias, invokes lambda with the lambda alias and returns the 404 response" do
    struct = Belfrage.Struct.add(@get_request_struct, :request, %{subdomain: "example-branch"})
    struct = Belfrage.Struct.add(struct, :private, %{preview_mode: "on"})

    LambdaMock
    |> expect(:call, fn _role_arn = "webcore-lambda-role-arn",
                        _lambda_func = "pwa-lambda-function:example-branch",
                        _payload = %{body: nil, headers: %{country: "gb"}, httpMethod: "GET"},
                        _request_id = "gerald-the-get-request",
                        _opts = [] ->
      @web_core_404_lambda_response
    end)

    thing = Belfrage.handle(struct)

    assert thing.response.http_status == 404
    assert thing.response.body == "404 - not found"
  end

  test "POST request invokes lambda service with Lambda transformer" do
    LambdaMock
    |> expect(:call, fn _role_arn = "webcore-lambda-role-arn",
                        _lambda_func = "pwa-lambda-function:test",
                        _payload = %{
                          body: ~s({"some": "data please"}),
                          headers: %{country: "gb"},
                          httpMethod: "POST"
                        },
                        _request_id = "pete-the-post-request",
                        _opts = [] ->
      @web_core_lambda_response
    end)

    Belfrage.handle(@post_request_struct)
  end

  @redirect_request_struct %Struct{
    private: %Struct.Private{
      loop_id: "SportVideos"
    },
    request: %Struct.Request{
      path: "/_web_core",
      method: "GET",
      country: "gb",
      host: "www.bbc.com",
      scheme: :http,
      request_id: "ronnie-the-redirect"
    }
  }

  test "A HTTP request redirects to https, and doesn't call the lambda" do
    LambdaMock
    |> expect(:call, 0, fn _role_arn, _func_name,  _payload, _request_id, _opts -> :this_should_not_be_called end)

    response_struct = Belfrage.handle(@redirect_request_struct)

    assert response_struct.response.http_status == 302
  end

  describe "with seeded cache" do
    setup do
      :ets.delete_all_objects(:cache)

      request_for_seeded_response = %Struct{
        private: %Struct.Private{
          loop_id: "SportVideos",
          production_environment: "test"
        },
        request: %Struct.Request{
          path: "/_seeded_request",
          method: "GET",
          country: "gb",
          request_id: "simon-the-seeded-request"
        }
      }

      seeded_response = %Belfrage.Struct.Response{
        body: :zlib.gzip(~s({"hi": "bonjour"})),
        headers: %{"content-type" => "application/json", "content-encoding" => "gzip"},
        http_status: 200,
        cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
      }

      Test.Support.Helper.insert_cache_seed(
        id: Belfrage.RequestHash.generate(request_for_seeded_response).request.request_hash,
        response: seeded_response,
        expires_in: :timer.hours(6),
        last_updated: Belfrage.Timer.now_ms()
      )

      %{
        request: request_for_seeded_response
      }
    end

    test "serves plain text from compressed cache when gzip is not accepted", %{request: request_struct} do
      assert %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 body: ~s({"hi": "bonjour"}),
                 headers: headers
               }
             } = Belfrage.handle(request_struct)

      refute Map.has_key?(headers, "content-encoding")
    end

    test "serves gzip content from compressed cache when gzip is accepted", %{request: request_struct} do
      struct_accepts_gzip = request_struct |> Struct.add(:request, %{accept_encoding: "gzip, br, deflate"})

      assert %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 body: compressed_body,
                 headers: %{
                   "content-encoding" => "gzip"
                 }
               }
             } = Belfrage.handle(struct_accepts_gzip)

      assert_gzipped(compressed_body, ~s({"hi": "bonjour"}))
    end
  end
end
