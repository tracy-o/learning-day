defmodule Belfrage.ResponseTransformers.CompressionAsRequestedTest do
  alias Belfrage.ResponseTransformers.CompressionAsRequested
  alias Belfrage.Struct
  use ExUnit.Case
  import Test.Support.Helper, only: [assert_gzipped: 2]

  setup do
    %{
      struct_fixture: %Struct{
        response: %Struct.Response{
          body: :zlib.gzip("<p>Hi. I am some content</p>"),
          headers: %{
            "content-encoding" => "gzip"
          },
          http_status: 200
        }
      }
    }
  end

  describe "when no accept_encoding value is set" do
    test "unzips the body in the struct & removes content-encoding response header", %{
      struct_fixture: struct_fixture
    } do
      assert %Struct.Response{
               body: "<p>Hi. I am some content</p>",
               headers: %{},
               http_status: 200
             } ==
               CompressionAsRequested.call(struct_fixture).response
    end
  end

  describe "when accept-encoding request header is set" do
    test "when gzip is accepted", %{struct_fixture: struct_fixture} do
      struct = Struct.add(struct_fixture, :request, %{accept_encoding: "gzip"})

      %Struct.Response{
        body: compressed_body,
        headers: %{
          "content-encoding" => "gzip"
        },
        http_status: 200
      } = CompressionAsRequested.call(struct).response

      assert_gzipped(compressed_body, "<p>Hi. I am some content</p>")
    end

    test "when gzip is not accepted", %{struct_fixture: struct_fixture} do
      struct = Struct.add(struct_fixture, :request, %{accept_encoding: "br, deflate, compression"})

      assert %Struct.Response{
               body: "<p>Hi. I am some content</p>",
               headers: %{},
               http_status: 200
             } ==
               CompressionAsRequested.call(struct).response
    end
  end
end
