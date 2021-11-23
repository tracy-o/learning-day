defmodule Belfrage.Services.WebcoreTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Response, Private}
  alias Belfrage.Services.Webcore
  alias Belfrage.Clients.LambdaMock
  alias Belfrage.XrayMock

  @successful_response {:ok, %{"statusCode" => 200, "headers" => %{}, "body" => "OK"}}

  test "call the lambda client" do
    struct = %Struct{
      request: %Request{
        request_id: "request-id",
        xray_trace_id: "xray-trace-id"
      },
      private: %Private{
        origin: "lambda-arn"
      }
    }

    credentials = Webcore.Credentials.get()
    request = Webcore.Request.build(struct)

    expect(LambdaMock, :call, fn ^credentials, "lambda-arn", ^request, "request-id", xray_trace_id: "xray-trace-id" ->
      @successful_response
    end)

    assert %Struct{response: response} = Webcore.dispatch(struct)

    assert response.http_status == 200
    assert response.body == "OK"
  end

  test "add xray subsegment" do
    struct = %Struct{}

    expect(XrayMock, :subsegment_with_struct_annotations, fn "webcore-service", ^struct, _fn ->
      %Response{body: "OK"}
    end)

    assert %Struct{response: %Response{body: "OK"}} = Webcore.dispatch(struct)
  end

  test "missing xray trace id" do
    expect(LambdaMock, :call, fn _credentials, _lambda_arn, _request, _request_id, [] ->
      @successful_response
    end)

    assert %Struct{response: %Response{body: "OK"}} = Webcore.dispatch(%Struct{})
  end

  test "convert values of response headers to strings" do
    stub_lambda_success(%{"headers" => %{"int" => 1, "bool" => true, "nil" => nil}})
    assert %Struct{response: %Response{headers: headers}} = Webcore.dispatch(%Struct{})
    assert headers == %{"int" => "1", "bool" => "true", "nil" => ""}
  end

  test "decode base64 encoded body" do
    stub_lambda_success(%{"body" => "RW5jb2RlZA==", "isBase64Encoded" => true})
    assert %Struct{response: %Response{body: "Encoded"}} = Webcore.dispatch(%Struct{})
  end

  # This test is just to demonstrate that we currently attempt to decode body
  # that is not actualy base64 encoded
  test "body is not actually base64 encoded" do
    stub_lambda_success(%{"body" => "Not encoded", "isBase64Encoded" => true})
    assert %Struct{response: response} = Webcore.dispatch(%Struct{})
    assert response.http_status == 200
    assert response.body == "6\x8B\xFFzw(u\xE7"
  end

  test "invoking lambda fails" do
    stub_lambda_error(:some_error)
    assert %Struct{response: response} = Webcore.dispatch(%Struct{})
    assert response.http_status == 500
    assert response.body == ""
  end

  test "lambda function not found" do
    stub_lambda_error(:function_not_found)

    assert %Struct{response: response} = Webcore.dispatch(%Struct{})
    assert response.http_status == 500
    assert response.body == ""

    struct = %Struct{private: %Private{preview_mode: "on"}}
    assert %Struct{response: response} = Webcore.dispatch(struct)
    assert response.http_status == 404
    assert response.body == "404 - not found"
  end

  test "invalid response format" do
    stub_lambda({:ok, %{"some" => "unexpected format"}})
    assert %Struct{response: response} = Webcore.dispatch(%Struct{})
    assert response.http_status == 500
    assert response.body == ""
  end

  defp stub_lambda_success(attrs) do
    stub_lambda({:ok, Map.merge(%{"statusCode" => 200, "headers" => %{}, "body" => "OK"}, attrs)})
  end

  defp stub_lambda_error(error) do
    stub_lambda({:error, error})
  end

  defp stub_lambda(response) do
    stub(LambdaMock, :call, fn _credentials, _arn, _request, _request_id, _opts ->
      response
    end)
  end
end
