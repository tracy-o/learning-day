defmodule Belfrage.Clients.CCPTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  alias Belfrage.Clients.CCP
  alias Belfrage.{Envelope, Envelope.Request, Envelope.Response}

  describe "put/2" do
    test "sends request and request hash as cast" do
      envelope = %Envelope{
        request: %Request{request_hash: "/news/live/cb5fooc91cd8b32dcec1fe441a0854fd"},
        response: %Response{body: "<h1>Hi</h1>"}
      }

      assert :ok == CCP.put(envelope, self())

      assert_received(
        {:"$gen_cast", {:put, "/news/live/cb5fooc91cd8b32dcec1fe441a0854fd", %Response{body: "<h1>Hi</h1>"}}}
      )
    end

    test "sends request globally and request hash as cast" do
      envelope = %Envelope{
        request: %Request{request_hash: "/news/live/cb5fooc91cd8b32dcec1fe441a0854fd"},
        response: %Response{body: "<h1>Hi</h1>"}
      }

      :global.register_name(:belfrage_ccp_test, self())

      assert :ok == CCP.put(envelope, {:global, :belfrage_ccp_test})

      assert_received(
        {:"$gen_cast", {:put, "/news/live/cb5fooc91cd8b32dcec1fe441a0854fd", %Response{body: "<h1>Hi</h1>"}}}
      )
    end

    test "returns :error whith non existant target" do
      envelope = %Envelope{
        request: %Request{request_hash: "/news/live/cb5fooc91cd8b32dcec1fe441a0854fd"},
        response: %Response{body: "<h1>Hi</h1>"}
      }

      assert :error == CCP.put(envelope, {:global, :foo})
    end
  end

  describe "fetch/1" do
    setup do
      %{
        s3_response_body:
          %Belfrage.Envelope.Response{
            body: :zlib.gzip(~s({"hi": "bonjour"})),
            headers: %{"content-type" => "application/json", "content-encoding" => "gzip"},
            http_status: 200,
            cache_directive: %Belfrage.CacheControl{cacheability: "public", max_age: 30}
          }
          |> :erlang.term_to_binary()
      }
    end

    test "correctly sends GET request to S3", %{s3_response_body: s3_response_body} do
      expected_s3_request =
        Finch.build(
          :get,
          "https://belfrage-distributed-cache-test.s3-eu-west-1.amazonaws.com/sport/cb5fooc91cd8b32dcec1fe441a0854fd"
        )

      FinchMock
      |> expect(:request, fn ^expected_s3_request, _name, _opts ->
        {:ok,
         %Finch.Response{
           status: 200,
           body: s3_response_body,
           headers: []
         }}
      end)

      CCP.fetch("/sport/cb5fooc91cd8b32dcec1fe441a0854fd")
    end

    test "correctly sends GET request for home page", %{s3_response_body: s3_response_body} do
      expected_s3_request =
        Finch.build(
          :get,
          "https://belfrage-distributed-cache-test.s3-eu-west-1.amazonaws.com/cb5fooc91cd8b32dcec1fe441a0854fd"
        )

      FinchMock
      |> expect(:request, fn ^expected_s3_request, _name, _opts ->
        {:ok,
         %Finch.Response{
           status: 200,
           body: s3_response_body,
           headers: []
         }}
      end)

      CCP.fetch("/cb5fooc91cd8b32dcec1fe441a0854fd")
    end

    test "converts binary format of erlang terms in response, to erlang terms", %{s3_response_body: s3_response_body} do
      FinchMock
      |> expect(:request, fn _req, _name, _opts ->
        {:ok,
         %Finch.Response{
           status: 200,
           body: s3_response_body,
           headers: []
         }}
      end)

      fallback_response = :erlang.binary_to_term(s3_response_body)
      assert {:ok, fallback_response} == CCP.fetch("/news/live/cb5fooc91cd8b32dcec1fe441a0854fd")
    end
  end

  test "when item does not exist in S3" do
    FinchMock
    |> expect(:request, fn _req, _name, _opts ->
      {:ok,
       %Finch.Response{
         status: 403,
         body: "",
         headers: []
       }}
    end)

    assert {:ok, :content_not_found} == CCP.fetch("/news/live/cb5fooc91cd8b32dcec1fe441a0854fd")
  end

  test "S3 returns unexpected status code" do
    FinchMock
    |> expect(:request, fn _req, _name, _opts ->
      {:ok,
       %Finch.Response{
         status: 202,
         body: "",
         headers: []
       }}
    end)

    assert {:ok, :content_not_found} == CCP.fetch("/news/live/cb5fooc91cd8b32dcec1fe441a0854fd")
  end

  test "when HTTP client returns an error" do
    FinchMock
    |> expect(:request, fn _req, _name, _opts ->
      {:error, %Mint.TransportError{reason: :timeout}}
    end)

    assert {:ok, :content_not_found} == CCP.fetch("/news/live/cb5fooc91cd8b32dcec1fe441a0854fd")
  end
end
