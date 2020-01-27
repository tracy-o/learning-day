defmodule Belfrage.Services.Webcore.ResponseTest do
  alias Belfrage.Struct
  alias Belfrage.Services.Webcore.Response

  use ExUnit.Case

  test "when content is base64 encoded response" do
    assert %Struct.Response{
             http_status: 200,
             headers: %{},
             body: "<p>Hello</p>"
           } =
             Response.build(
               {:ok, %{"body" => "PHA+SGVsbG88L3A+", "isBase64Encoded" => true, "statusCode" => 200, "headers" => %{}}}
             )
  end

  test "when body is base64 encoded, but missing other keys" do
    assert %Struct.Response{
             http_status: 500,
             headers: %{},
             body: ""
           } = Response.build({:ok, %{"body" => "PHA+SGVsbG88L3A+", "isBase64Encoded" => true, "statusCode" => 200}})
  end

  test "when fails to decode base64 response" do
    assert %Struct.Response{
             http_status: 500,
             headers: %{},
             body: ""
           } = Response.build({:ok, %{"body" => "i am not base 64 encoded", "isBase64Encoded" => true}})
  end
end
