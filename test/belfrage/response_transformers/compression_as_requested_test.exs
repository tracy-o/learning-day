defmodule Belfrage.ResponseTransformers.CompressionAsRequestedTest do
  alias Belfrage.ResponseTransformers.CompressionAsRequested
  alias Belfrage.Struct
  use ExUnit.Case

  @test_body "<p>Hi. I am some content</p>"

  describe "when content-encoding header contains gzip" do
    test "when accept_encoding contains gzip, passes the struct through untouched" do
      struct = %Struct{
        request: %Struct.Request{accept_encoding: "gzip"},
        response:
          response = %Struct.Response{
            body: :zlib.gzip(@test_body),
            http_status: 200,
            headers: %{"content-encoding" => "gzip"}
          }
      }

      assert_response(response, CompressionAsRequested.call(struct))
    end

    test "when accept_encoding does not contain gzip, unzips the body in the struct & removes content-encoding response header" do
      struct = %Struct{
        request: %Struct.Request{accept_encoding: "br,deflate"},
        response: %Struct.Response{
          body: :zlib.gzip(@test_body),
          http_status: 200,
          headers: %{"content-encoding" => "gzip"}
        }
      }

      assert_response(
        %Struct.Response{
          body: @test_body,
          http_status: 200,
          headers: %{}
        },
        CompressionAsRequested.call(struct)
      )
    end
  end

  describe "when content-encoding header does not contain gzip" do
    test "when accept_encoding contains gzip, passes the struct through untouched" do
      struct = %Struct{
        request: %Struct.Request{accept_encoding: "gzip"},
        response:
          response = %Struct.Response{
            body: :zlib.gzip(@test_body),
            http_status: 200,
            headers: %{}
          }
      }

      assert_response(response, CompressionAsRequested.call(struct))
    end

    test "when accept_encoding does not contain gzip, passes the struct through untouched" do
      struct = %Struct{
        request: %Struct.Request{accept_encoding: "deflate"},
        response:
          response = %Struct.Response{
            body: @test_body,
            http_status: 200,
            headers: %{}
          }
      }

      assert_response(response, CompressionAsRequested.call(struct))
    end

    defp assert_response(expected_response, {:ok, actual_struct}) do
      assert expected_response == actual_struct.response
    end
  end
end
