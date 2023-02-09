defmodule Belfrage.ResponseTransformers.CompressionAsRequestedTest do
  alias Belfrage.ResponseTransformers.CompressionAsRequested
  alias Belfrage.Envelope
  use ExUnit.Case

  @test_body "<p>Hi. I am some content</p>"

  describe "when content-encoding header contains gzip" do
    test "when accept_encoding contains gzip, passes the envelope through untouched" do
      envelope = %Envelope{
        request: %Envelope.Request{accept_encoding: "gzip"},
        response:
          response = %Envelope.Response{
            body: :zlib.gzip(@test_body),
            http_status: 200,
            headers: %{"content-encoding" => "gzip"}
          }
      }

      assert_response(response, CompressionAsRequested.call(envelope))
    end

    test "when accept_encoding does not contain gzip, unzips the body in the envelope & removes content-encoding response header" do
      envelope = %Envelope{
        request: %Envelope.Request{accept_encoding: "br,deflate"},
        response: %Envelope.Response{
          body: :zlib.gzip(@test_body),
          http_status: 200,
          headers: %{"content-encoding" => "gzip"}
        }
      }

      assert_response(
        %Envelope.Response{
          body: @test_body,
          http_status: 200,
          headers: %{}
        },
        CompressionAsRequested.call(envelope)
      )
    end
  end

  describe "when content-encoding header does not contain gzip" do
    test "when accept_encoding contains gzip, passes the envelope through untouched" do
      envelope = %Envelope{
        request: %Envelope.Request{accept_encoding: "gzip"},
        response:
          response = %Envelope.Response{
            body: :zlib.gzip(@test_body),
            http_status: 200,
            headers: %{}
          }
      }

      assert_response(response, CompressionAsRequested.call(envelope))
    end

    test "when accept_encoding does not contain gzip, passes the envelope through untouched" do
      envelope = %Envelope{
        request: %Envelope.Request{accept_encoding: "deflate"},
        response:
          response = %Envelope.Response{
            body: @test_body,
            http_status: 200,
            headers: %{}
          }
      }

      assert_response(response, CompressionAsRequested.call(envelope))
    end

    defp assert_response(expected_response, {:ok, actual_envelope}) do
      assert expected_response == actual_envelope.response
    end
  end
end
