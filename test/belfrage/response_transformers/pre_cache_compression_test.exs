defmodule Belfrage.ResponseTransformers.PreCacheCompressionTest do
  alias Belfrage.ResponseTransformers.PreCacheCompression
  alias Belfrage.Envelope
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [assert_gzipped: 2]
  import ExUnit.CaptureLog

  describe "when content-encoding response header is set" do
    test "when encoding is gzip, the body and content-encoding header are not modified" do
      body = :zlib.gzip("<p>Hello, I'm gzipped</p>")

      envelope = %Envelope{
        response: %Envelope.Response{
          body: body,
          headers: %{
            "content-encoding" => "gzip"
          }
        }
      }

      assert {:ok,
              %Envelope{
                response: %Envelope.Response{
                  body: ^body,
                  headers: %{
                    "content-encoding" => "gzip"
                  }
                }
              }} = PreCacheCompression.call(envelope)
    end

    test "when encoding is not supported it should return a 415" do
      envelope = %Envelope{
        response: %Envelope.Response{
          body: :zlib.compress("<p>compress</p>"),
          headers: %{
            "content-encoding" => "compress"
          }
        }
      }

      assert {:ok,
              %Envelope{
                response: %Envelope.Response{
                  body: "",
                  http_status: 415
                }
              }} = PreCacheCompression.call(envelope)
    end
  end

  describe "when content-encoding response header is not set and response is a 200" do
    test "the response body is gzipped, the content-encoding header is added and data is logged" do
      envelope = %Envelope{
        request: %Envelope.Request{
          path: "/non-compressed/path"
        },
        response: %Envelope.Response{
          body: "I am some plain text",
          http_status: 200
        },
        private: %Envelope.Private{
          platform: "SomePlatform"
        }
      }

      log =
        capture_log(fn ->
          assert {:ok,
                  %Envelope{
                    response: %Envelope.Response{
                      body: compressed_body,
                      http_status: 200,
                      headers: %{
                        "content-encoding" => "gzip"
                      }
                    }
                  }} = PreCacheCompression.call(envelope)

          assert_gzipped(compressed_body, "I am some plain text")
        end)

      assert log =~ ~r/\"level\":\"info\"/
      assert log =~ ~r/\"metadata\":{}/
      assert log =~ ~r/\"msg\":\"Content was pre-cache compressed\"/
      assert log =~ ~r/\"path\":\"\/non-compressed\/path\"/
      assert log =~ ~r/\"platform\":\"SomePlatform\"/
    end
  end

  describe "when content-encoding response header is not set, but response is not a 200" do
    test "the response isn't gzipped, envelope is returned unmodified" do
      envelope = %Envelope{
        response: %Envelope.Response{
          body: "I am a non 200 response",
          http_status: 404
        }
      }

      assert {:ok, envelope} == PreCacheCompression.call(envelope)
    end
  end
end
