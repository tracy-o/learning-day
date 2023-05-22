defmodule Belfrage.Services.WebcoreTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox
  use Belfrage.Test.XrayHelper

  import Belfrage.Test.MetricsHelper
  alias Belfrage.Envelope
  alias Belfrage.Envelope.{Request, Response, Private}
  alias Belfrage.Services.Webcore
  alias Belfrage.Clients.LambdaMock

  @successful_response {:ok, %{"statusCode" => 200, "headers" => %{}, "body" => "OK"}}
  @route_state_id {"SomeRouteSpec", "Webcore"}

  @default_envelope %Envelope{
    request: %Request{
      request_id: "request-id",
      xray_segment: build_segment(sampled: false, name: "Belfrage")
    },
    private: %Private{
      route_state_id: @route_state_id,
      origin: "lambda-arn"
    }
  }

  test "call the lambda client" do
    credentials = Webcore.Credentials.get()
    request = Webcore.Request.build(@default_envelope)

    expect(LambdaMock, :call, fn ^credentials, "lambda-arn", ^request, [xray_trace_id: _trace_id] ->
      @successful_response
    end)

    assert %Envelope{response: response} = Webcore.dispatch(@default_envelope)
    assert response.http_status == 200
    assert response.body == "OK"
  end

  test "still calls the lambda client, when xray_segment is nil" do
    nil_segment_envelope = put_in(@default_envelope.request.xray_segment, nil)

    credentials = Webcore.Credentials.get()
    request = Webcore.Request.build(nil_segment_envelope)

    expect(LambdaMock, :call, fn ^credentials, "lambda-arn", ^request, _options = [] ->
      @successful_response
    end)

    Webcore.dispatch(nil_segment_envelope)
  end

  test "tracks the duration of the lambda call" do
    stub_lambda_success()
    envelope = %Envelope{private: %Private{route_state_id: @route_state_id}}

    {_event, measurement, metadata} =
      intercept_metric(~w(webcore request stop)a, fn ->
        Webcore.dispatch(envelope)
      end)

    assert measurement.duration > 0
    assert metadata.route_spec == "SomeRouteSpec"
    assert metadata.platform == "Webcore"
  end

  test "convert values of response headers to strings" do
    stub_lambda_success(%{"headers" => %{"int" => 1, "bool" => true, "nil" => nil}})
    assert %Envelope{response: %Response{headers: headers}} = Webcore.dispatch(%Envelope{})
    assert headers == %{"int" => "1", "bool" => "true", "nil" => ""}
  end

  test "decode base64 encoded body" do
    stub_lambda_success(%{"body" => "RW5jb2RlZA==", "isBase64Encoded" => true})
    assert %Envelope{response: %Response{body: "Encoded"}} = Webcore.dispatch(%Envelope{})
  end

  # This test is just to demonstrate that we currently attempt to decode body
  # that is not actualy base64 encoded
  test "body is not actually base64 encoded" do
    stub_lambda_success(%{"body" => "Not encoded", "isBase64Encoded" => true})
    assert %Envelope{response: response} = Webcore.dispatch(%Envelope{})
    assert response.http_status == 200
    assert response.body == "6\x8B\xFFzw(u\xE7"
  end

  test "invoking lambda fails" do
    stub_lambda_error(:some_error)
    envelope = %Envelope{private: %Private{route_state_id: @route_state_id, platform: "Webcore", spec: "SomeRouteSpec"}}

    assert_metric(
      {~w(webcore error)a, %{error_code: :some_error, route_spec: "SomeRouteSpec", platform: "Webcore"}},
      fn ->
        assert %Envelope{response: response} = Webcore.dispatch(envelope)
        assert response.http_status == 500
        assert response.body == ""
      end
    )
  end

  test "lambda function not found" do
    stub_lambda_error(:function_not_found)

    assert %Envelope{response: response} = Webcore.dispatch(%Envelope{})
    assert response.http_status == 500
    assert response.body == ""

    envelope = %Envelope{private: %Private{preview_mode: "on"}}
    assert %Envelope{response: response} = Webcore.dispatch(envelope)
    assert response.http_status == 404
    assert response.body == "404 - not found"
  end

  test "invalid response format" do
    stub_lambda({:ok, %{"some" => "unexpected format"}})
    envelope = %Envelope{private: %Private{route_state_id: @route_state_id, platform: "Webcore", spec: "SomeRouteSpec"}}

    assert_metric(
      {~w(webcore error)a, %{error_code: :invalid_web_core_contract, route_spec: "SomeRouteSpec", platform: "Webcore"}},
      fn ->
        assert %Envelope{response: response} = Webcore.dispatch(envelope)
        assert response.http_status == 500
        assert response.body == ""
      end
    )
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
