defmodule Belfrage.ResponseTransformers.ElectoralCommissionResponseHandlerTest do
  use ExUnit.Case

  alias Belfrage.Envelope
  alias Belfrage.ResponseTransformers.ElectoralCommissionResponseHandler

  test "removes response vary header" do
    {:ok, result} =
      ElectoralCommissionResponseHandler.call(%Envelope{
        response: %Envelope.Response{
          headers: %{
            "content-type" => "application/json",
            "cache-control" => "public, max-age=60",
            "vary" => "accept-encoding"
          }
        }
      })

    refute Map.has_key?(result.response.headers, "vary")
    assert Map.has_key?(result.response.headers, "content-type")
    assert Map.has_key?(result.response.headers, "cache-control")
  end

  test "removes cache-control and add news cache-control header" do
    {:ok, result} =
      ElectoralCommissionResponseHandler.call(%Envelope{
        response: %Envelope.Response{
          headers: %{
            "cache-control" => "public, max-age=60"
          }
        }
      })

    assert Map.fetch(result.response.headers, "cache-control") == {:ok, "public, max-age=5"}
  end
end
