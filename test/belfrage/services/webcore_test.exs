defmodule Belfrage.Services.WebcoreTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox
  use Belfrage.Test.XrayHelper

  import Belfrage.Test.MetricsHelper
  alias Belfrage.Struct
  alias Belfrage.Struct.{Request, Response, Private}
  alias Belfrage.Services.Webcore
  alias Belfrage.Clients.LambdaMock

  @successful_response {:ok, %{"statusCode" => 200, "headers" => %{}, "body" => "OK"}}

  @default_struct %Struct{
    request: %Request{
      request_id: "request-id",
      xray_segment: build_segment(sampled: false, name: "Belfrage")
    },
    private: %Private{
      route_state_id: "SomeRouteSpec",
      origin: "lambda-arn"
    }
  }

  test "call the lambda client" do
    credentials = Webcore.Credentials.get()
    request = Webcore.Request.build(@default_struct)

    expect(LambdaMock, :call, fn ^credentials, "lambda-arn", ^request, [xray_trace_id: _trace_id] ->
      @successful_response
    end)

    assert_metric({~w(webcore response)a, %{status_code: 200, route_spec: "SomeRouteSpec"}}, fn ->
      assert %Struct{response: response} = Webcore.dispatch(@default_struct)
      assert response.http_status == 200
      assert response.body == "OK"
    end)
  end

  test "still calls the lambda client, when xray_segment is nil" do
    nil_segment_struct = put_in(@default_struct.request.xray_segment, nil)

    credentials = Webcore.Credentials.get()
    request = Webcore.Request.build(nil_segment_struct)

    expect(LambdaMock, :call, fn ^credentials, "lambda-arn", ^request, _options = [] ->
      @successful_response
    end)

    Webcore.dispatch(nil_segment_struct)
  end

  test "tracks the duration of the lambda call" do
    stub_lambda_success()
    struct = %Struct{private: %Private{route_state_id: "SomeRouteSpec"}}

    {_event, measurement, metadata} =
      intercept_metric(~w(webcore request stop)a, fn ->
        Webcore.dispatch(struct)
      end)

    assert measurement.duration > 0
    assert metadata.route_spec == "SomeRouteSpec"
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
    struct = %Struct{private: %Private{route_state_id: "SomeRouteSpec"}}

    assert_metric({~w(webcore error)a, %{error_code: :some_error, route_spec: "SomeRouteSpec"}}, fn ->
      assert %Struct{response: response} = Webcore.dispatch(struct)
      assert response.http_status == 500
      assert response.body == ""
    end)
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
    struct = %Struct{private: %Private{route_state_id: "SomeRouteSpec"}}

    assert_metric({~w(webcore error)a, %{error_code: :invalid_web_core_contract, route_spec: "SomeRouteSpec"}}, fn ->
      assert %Struct{response: response} = Webcore.dispatch(struct)
      assert response.http_status == 500
      assert response.body == ""
    end)
  end

  defp stub_lambda_success(attrs \\ %{}) do
    stub_lambda({:ok, Map.merge(%{"statusCode" => 200, "headers" => %{}, "body" => "OK"}, attrs)})
  end

  defp stub_lambda_error(error) do
    stub_lambda({:error, error})
  end

  defp stub_lambda(response) do
    stub(LambdaMock, :call, fn _credentials, _arn, _request, _opts ->
      response
    end)
  end
end
