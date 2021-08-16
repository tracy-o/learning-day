defmodule Belfrage.Services.Webcore.ResponseTest do
  alias Belfrage.Struct
  alias Belfrage.Services.Webcore.Response

  use ExUnit.Case

  test "when content is base64 encoded response, the response is base64 decoded" do
    assert %Struct.Response{
             http_status: 200,
             headers: %{},
             body: "<p>Hello</p>"
           } =
             Response.build(
               {:ok, %{"body" => "PHA+SGVsbG88L3A+", "isBase64Encoded" => true, "statusCode" => 200, "headers" => %{}}},
               "off"
             )
  end

  test "when body is base64 encoded, but missing other keys a 500 is returned" do
    assert %Struct.Response{
             http_status: 500,
             headers: %{},
             body: ""
           } =
             Response.build(
               {:ok, %{"body" => "PHA+SGVsbG88L3A+", "isBase64Encoded" => true, "statusCode" => 200}},
               "off"
             )
  end

  test "when fails to decode base64 response a 500 is returned" do
    assert %Struct.Response{
             http_status: 500,
             headers: %{},
             body: ""
           } = Response.build({:ok, %{"body" => "i am not base 64 encoded", "isBase64Encoded" => true}}, "off")
  end

  describe "response headers" do
    test "values are converted to strings" do
      assert %Struct.Response{
               headers: %{
                 "content-length" => "0",
                 "a-header" => "true",
                 "another-header" => "false",
                 "a-nil-header" => ""
               }
             } =
               Response.build(
                 {:ok,
                  %{
                    "body" => "",
                    "isBase64Encoded" => false,
                    "statusCode" => 404,
                    "headers" => %{
                      "content-length" => 0,
                      "a-header" => true,
                      "another-header" => false,
                      "a-nil-header" => nil
                    }
                  }},
                 "off"
               )
    end
  end
end
