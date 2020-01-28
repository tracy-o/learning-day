defmodule Belfrage.ResponseTransformers.PreCacheCompressionTest do
  alias Belfrage.ResponseTransformers.PreCacheCompression
  alias Belfrage.Struct
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [assert_gzipped: 2]

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

    test "when encoding is not supported" do
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
                 http_status: 500
               }
             } = PreCacheCompression.call(struct)
    end
  end

  describe "when content-encoding response header is not set" do
    test "the response body is gzipped and the content-encoding header is added" do
      struct = %Struct{
        response: %Struct.Response{
          body: "I am some plain text"
        }
      }

      assert %Struct{
               response: %Struct.Response{
                 body: compressed_body,
                 headers: %{
                   "content-encoding" => "gzip"
                 }
               }
             } = PreCacheCompression.call(struct)

      assert_gzipped(compressed_body, "I am some plain text")
    end
  end
end
