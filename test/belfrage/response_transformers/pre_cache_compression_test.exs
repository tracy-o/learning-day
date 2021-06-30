defmodule Belfrage.ResponseTransformers.PreCacheCompressionTest do
  alias Belfrage.ResponseTransformers.PreCacheCompression
  alias Belfrage.Struct
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [assert_gzipped: 2]
  import ExUnit.CaptureLog

  describe "when content-encoding response header is set" do
    test "when encoding is gzip, the body and content-encoding header are not modified" do
      body = :zlib.gzip("<p>Hello, I'm gzipped</p>")

      struct = %Struct{
        response: %Struct.Response{
          body: body,
          headers: %{
            "content-encoding" => "gzip"
          }
        }
      }

      assert %Struct{
               response: %Struct.Response{
                 body: ^body,
                 headers: %{
                   "content-encoding" => "gzip"
                 }
               }
             } = PreCacheCompression.call(struct)
    end

    test "when encoding is not supported it should return a 415" do
      struct = %Struct{
        response: %Struct.Response{
          body: :zlib.compress("<p>compress</p>"),
          headers: %{
            "content-encoding" => "compress"
          }
        }
      }

      assert %Struct{
               response: %Struct.Response{
                 body: "",
                 http_status: 415
               }
             } = PreCacheCompression.call(struct)
    end
  end

  describe "when content-encoding response header is not set and response is a 200" do
    test "the response body is gzipped, the content-encoding header is added and data is logged" do
      struct = %Struct{
        request: %Struct.Request{
          path: "/non-compressed/path"
        },
        response: %Struct.Response{
          body: "I am some plain text",
          http_status: 200
        },
        private: %Struct.Private{
          platform: SomePlatform
        }
      }

      assert capture_log(fn ->
               assert %Struct{
                        response: %Struct.Response{
                          body: compressed_body,
                          http_status: 200,
                          headers: %{
                            "content-encoding" => "gzip"
                          }
                        }
                      } = PreCacheCompression.call(struct)

               assert_gzipped(compressed_body, "I am some plain text")
             end) =~
               ~r/\"level\":\"info\",\"metadata\":{},\"msg\":\"Content was pre-cache compressed\",\"path\":\"\/non-compressed\/path\",\"platform\":\"Elixir.SomePlatform\"/
    end
  end

  describe "when content-encoding resoponse header is not set, but response is not a 200" do
    test "the response isn't gzipped, struct is returned unmodified" do
      struct = %Struct{
        request: %Struct.Request{
          path: "/non-compressed/path"
        },
        response: %Struct.Response{
          body: "I am a non 200 response",
          http_status: 404
        },
        private: %Struct.Private{
          platform: SomePlatform
        }
      }

      assert struct == PreCacheCompression.call(struct)
    end
  end
end
