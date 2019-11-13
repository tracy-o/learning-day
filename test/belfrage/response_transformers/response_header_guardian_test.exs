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
            "connection" => "close"
          }
        }
      })

    refute Map.has_key?(result.response.headers, "connection")
  end

  test "does not affect any other values in the response" do
    result =
      ResponseHeaderGuardian.call(%Struct{
        response: %Struct.Response{
          body: "<p>some content</p>",
          http_status: 200,
          headers: %{}
        }
      })

    assert result = %Struct.Response{
             body: "<p>some content</p>",
             http_status: 200,
             headers: %{}
           }
  end
end
