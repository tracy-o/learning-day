defmodule Belfrage.ResponseTransformers.CompressionAsRequestedTest do
  alias Belfrage.ResponseTransformers.CompressionAsRequested
  alias Belfrage.Struct
  use ExUnit.Case

  describe "when content-encoding header contains gzip" do
    test "when accept_encoding contains gzip, passes the struct through untouched" do
      struct = %Struct{
        request: %Struct.Request{accept_encoding: "gzip"},
        response: %Struct.Response{
          body: :zlib.gzip("<p>Hi. I am some content</p>"),
          http_status: 200,
          headers: %{"content-encoding" => "gzip"}
        }
      }

      assert %Struct.Response{
               body: :zlib.gzip("<p>Hi. I am some content</p>"),
               http_status: 200,
               headers: %{"content-encoding" => "gzip"}
             } ==
               CompressionAsRequested.call(struct).response
    end

    test "when accept_encoding does not contain gzip, unzips the body in the struct & removes content-encoding response header" do
      struct = %Struct{
        request: %Struct.Request{accept_encoding: "br,deflate"},
        response: %Struct.Response{
          body: :zlib.gzip("<p>Hi. I am some content</p>"),
          http_status: 200,
          headers: %{"content-encoding" => "gzip"}
        }
      }

      assert %Struct.Response{
               body: "<p>Hi. I am some content</p>",
               http_status: 200,
               headers: %{}
             } == CompressionAsRequested.call(struct).response
    end
  end

  describe "when content-encoding header does not contain gzip" do
    test "when accept_encoding contains gzip, passes the struct through untouched" do
      struct = %Struct{
        request: %Struct.Request{accept_encoding: "gzip"},
        response: %Struct.Response{
          body: :zlib.gzip("<p>Hi. I am some content</p>"),
          http_status: 200,
          headers: %{}
        }
      }

      assert %Struct.Response{
               body: :zlib.gzip("<p>Hi. I am some content</p>"),
               http_status: 200,
               headers: %{}
             } ==
               CompressionAsRequested.call(struct).response
    end

    test "when accept_encoding does not contain gzip, passes the struct through untouched" do
      struct = %Struct{
        request: %Struct.Request{accept_encoding: "deflate"},
        response: %Struct.Response{
          body: "<p>Hi. I am some content</p>",
          http_status: 200,
          headers: %{}
        }
      }

      assert %Struct.Response{
               body: "<p>Hi. I am some content</p>",
               http_status: 200,
               headers: %{}
             } ==
               CompressionAsRequested.call(struct).response
    end
  end
end
