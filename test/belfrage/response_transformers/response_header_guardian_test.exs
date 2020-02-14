defmodule Belfrage.ResponseTransformers.ResponseHeaderGuardianTest do
  alias Belfrage.Struct
  use ExUnit.Case

  alias Belfrage.ResponseTransformers.ResponseHeaderGuardian

  doctest ResponseHeaderGuardian, import: true

  test "removes connection response header" do
    result =
      ResponseHeaderGuardian.call(%Struct{
        response: %Struct.Response{
          headers: %{
            "content-type" => "application/json",
            "connection" => "close"
          }
        }
      })

    refute Map.has_key?(result.response.headers, "connection")
    assert Map.has_key?(result.response.headers, "content-type")
  end

  test "removes transfer-encoding header" do
    result =
      ResponseHeaderGuardian.call(%Struct{
        response: %Struct.Response{
          headers: %{
            "content-type" => "application/json",
            "transfer-encoding" => "chunked"
          }
        }
      })

    refute Map.has_key?(result.response.headers, "transfer-encoding")
    assert Map.has_key?(result.response.headers, "content-type")
  end

  test "does not affect any other response headers" do
    result =
      ResponseHeaderGuardian.call(%Struct{
        response: %Struct.Response{
          body: "<p>some content</p>",
          http_status: 200,
          headers: %{
            "content-type" => "application/json"
          }
        }
      })

    assert %Struct{
             response: %Struct.Response{
               body: "<p>some content</p>",
               http_status: 200,
               headers: %{
                 "content-type" => "application/json"
               }
             }
           } = result
  end
end
