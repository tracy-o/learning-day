defmodule Belfrage.Services.Webcore.ResponseTest do
  alias Belfrage.Struct
  alias Belfrage.Services.Webcore.Response

  use ExUnit.Case

  describe "with preview mode off" do
    test "when content is base64 encoded response, the response is base64 decoded" do
      assert %Struct.Response{
               http_status: 200,
               headers: %{},
               body: "<p>Hello</p>"
             } =
               Response.build(
                 {:ok,
                  %{"body" => "PHA+SGVsbG88L3A+", "isBase64Encoded" => true, "statusCode" => 200, "headers" => %{}}},
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
                 {:ok, %{"body" => "PHA+SGVsbG88L3A+", "isBase64Encoded" => true, "statuscode" => 200}},
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

    test "when {:error, :function_not_found} is the response" do
      assert %Struct.Response{
               http_status: 500,
               headers: %{},
               body: ""
             } = Response.build({:error, :function_not_found}, "off")
    end
  end

  describe "with preview_mode on" do
    test "when content is base64 encoded response, the response is base64 decoded" do
      assert %Struct.Response{
               http_status: 200,
               headers: %{},
               body: "<p>Hello</p>"
             } =
               Response.build(
                 {:ok,
                  %{"body" => "PHA+SGVsbG88L3A+", "isBase64Encoded" => true, "statusCode" => 200, "headers" => %{}}},
                 "on"
               )
    end

    test "when body is base64 encoded, but missing other keys a 500 is returned" do
      assert %Struct.Response{
               http_status: 500,
               headers: %{},
               body: ""
             } =
               Response.build(
                 {:ok, %{"body" => "PHA+SGVsbG88L3A+", "isBase64Encoded" => true, "statuscode" => 200}},
                 "on"
               )
    end

    test "when fails to decode base64 response a 500 is returned" do
      assert %Struct.Response{
               http_status: 500,
               headers: %{},
               body: ""
             } = Response.build({:ok, %{"body" => "i am not base 64 encoded", "isBase64Encoded" => true}}, "on")
    end

    test "when {:error, :function_not_found} is the response" do
      assert %Struct.Response{
               http_status: 404,
               headers: %{},
               body: "404 - not found"
             } = Response.build({:error, :function_not_found}, "on")
    end
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
