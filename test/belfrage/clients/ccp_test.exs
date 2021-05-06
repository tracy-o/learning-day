defmodule Belfrage.Clients.CCPTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  alias Belfrage.Clients.CCP
  alias Belfrage.{Struct, Struct.Request, Struct.Response}

  describe "put/2" do
    test "sends request and request hash as cast" do
      struct = %Struct{
        request: %Request{request_hash: "a-request-hash"},
        response: %Response{body: "<h1>Hi</h1>"}
      }

      assert :ok == CCP.put(struct, self())

      assert_received({:"$gen_cast", {:put, "a-request-hash", %Response{body: "<h1>Hi</h1>"}}})
    end

    test "sends request globally and request hash as cast" do
      struct = %Struct{
        request: %Request{request_hash: "a-request-hash"},
        response: %Response{body: "<h1>Hi</h1>"}
      }

      :global.register_name(:belfrage_ccp_test, self())

      assert :ok == CCP.put(struct, {:global, :belfrage_ccp_test})

      assert_received({:"$gen_cast", {:put, "a-request-hash", %Response{body: "<h1>Hi</h1>"}}})
    end

    test "returns :error whith non existant target" do
      struct = %Struct{
        request: %Request{request_hash: "a-request-hash"},
        response: %Response{body: "<h1>Hi</h1>"}
      }

      assert :error == CCP.put(struct, {:global, :foo})
    end
  end

  describe "fetch/2" do
    setup do
      %{
        s3_response_body:
          %Belfrage.Struct.Response{
            body: :zlib.gzip(~s({"hi": "bonjour"})),
            headers: %{"content-type" => "application/json", "content-encoding" => "gzip"},
            http_status: 200,
            cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
          }
          |> :erlang.term_to_binary()
      }
    end

    test "correctly sends GET request to S3", %{s3_response_body: s3_response_body} do
      expected_s3_request = %Belfrage.Clients.HTTP.Request{
        headers: %{},
        method: :get,
        payload: "",
        timeout: 6000,
        url: "https://belfrage-distributed-cache-test.s3-eu-west-1.amazonaws.com/request-hash-123",
        request_id: "colin-the-ccp-request"
      }

      Belfrage.Clients.HTTPMock
      |> expect(:execute, fn ^expected_s3_request ->
        {:ok,
         Belfrage.Clients.HTTP.Response.new(%{
           status_code: 200,
           body: s3_response_body,
           headers: []
         })}
      end)

      CCP.fetch("request-hash-123", "colin-the-ccp-request")
    end

    test "converts binary format of erlang terms in response, to erlang terms", %{s3_response_body: s3_response_body} do
      Belfrage.Clients.HTTPMock
      |> expect(:execute, fn _request ->
        {:ok,
         Belfrage.Clients.HTTP.Response.new(%{
           status_code: 200,
           body: s3_response_body,
           headers: []
         })}
      end)

      fallback_response = :erlang.binary_to_term(s3_response_body)
      assert {:ok, :stale, fallback_response} == CCP.fetch("request-hash-123", "colin-the-ccp-request")
    end
  end

  test "when item does not exist in S3" do
    Belfrage.Clients.HTTPMock
    |> expect(:execute, fn _request ->
      {:ok,
       Belfrage.Clients.HTTP.Response.new(%{
         status_code: 403,
         body: "",
         headers: []
       })}
    end)

    assert {:ok, :content_not_found} == CCP.fetch("request-hash-123", "colin-the-ccp-request")
  end

  test "S3 returns unexpected status code" do
    Belfrage.Clients.HTTPMock
    |> expect(:execute, fn _request ->
      {:ok,
       Belfrage.Clients.HTTP.Response.new(%{
         status_code: 202,
         body: "",
         headers: []
       })}
    end)

    assert {:ok, :content_not_found} == CCP.fetch("request-hash-123", "colin-the-ccp-request")
  end

  test "when HTTP client returns an error" do
    Belfrage.Clients.HTTPMock
    |> expect(:execute, fn _request ->
      {:error, %Belfrage.Clients.HTTP.Error{reason: :timeout}}
    end)

    assert {:ok, :content_not_found} == CCP.fetch("request-hash-123", "colin-the-ccp-request")
  end
end
