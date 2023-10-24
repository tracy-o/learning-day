defmodule Belfrage.Xray.TelemetryTest do
  use ExUnit.Case, async: true
  use Belfrage.Test.XrayHelper

  alias Belfrage.Xray
  alias Belfrage.Envelope
  alias Belfrage.Envelope.Private

  @test_envelope %Envelope{
    private: %Private{
      email: "some@email.com",
      route_state_id: {"some_spec", "some_platform"},
      preview_mode: "off",
      production_environment: "test",
      runbook: "https://some.runbook/url"
    }
  }

  describe "webcore.request metric triggering handle_event/5" do
    setup do
      envelope = put_in(@test_envelope.request.xray_segment, build_segment(sampled: true))

      Xray.Telemetry.setup()

      Belfrage.Metrics.duration(~w(webcore request)a, %{envelope: envelope, client: MockXrayClient}, fn ->
        Process.sleep(1)
      end)

      assert_received {:mock_xray_client_data, webcore_subsegment}
      assert_received {:mock_xray_client_data, lambda_subsegment}

      webcore_subsegment = Jason.decode!(webcore_subsegment)
      lambda_subsegment = Jason.decode!(lambda_subsegment)
      %{webcore_subsegment: webcore_subsegment, lambda_subsegment: lambda_subsegment}
    end

    test "webcore subsegment is emitted from the client", %{webcore_subsegment: subsegment} do
      assert subsegment["name"] == "webcore-service"
    end

    test "lambda subsegment is emitted from the client", %{lambda_subsegment: subsegment} do
      assert subsegment["name"] == "invoke-lambda-call"
    end

    test "subsegments have start_time", %{webcore_subsegment: webcore_subsegment, lambda_subsegment: lambda_subsegment} do
      assert webcore_subsegment["start_time"]
      assert lambda_subsegment["start_time"]
    end

    test "subsegments have end_time", %{webcore_subsegment: webcore_subsegment, lambda_subsegment: lambda_subsegment} do
      assert webcore_subsegment["end_time"]
      assert lambda_subsegment["end_time"]
    end

    test "subsegments end_time is after start_time", %{
      webcore_subsegment: webcore_subsegment,
      lambda_subsegment: lambda_subsegment
    } do
      assert webcore_subsegment["end_time"] - webcore_subsegment["start_time"] > 0
      assert lambda_subsegment["end_time"] - lambda_subsegment["start_time"] > 0
    end

    test "webcore subsegment had annotations", %{webcore_subsegment: subsegment} do
      assert subsegment["annotations"]["route_state_id"] == "some_spec.some_platform"
    end
  end

  describe "handle_events/4 when xray segment is nil" do
    test "it should return nil" do
      envelope = put_in(@test_envelope.request.xray_segment, nil)

      assert nil ==
               Xray.Telemetry.handle_event(
                 :event,
                 %{start_time: 123_000, duration: 1000},
                 %{envelope: envelope},
                 :config
               )
    end

    test "no data is sent to the xray client" do
      envelope = put_in(@test_envelope.request.xray_segment, nil)

      Xray.Telemetry.setup()

      Belfrage.Metrics.duration(~w(webcore request)a, %{envelope: envelope, client: MockXrayClient}, fn ->
        Process.sleep(1)
      end)

      refute_received {:mock_xray_client_data, _webcore_subsegment}
      refute_received {:mock_xray_client_data, _lambda_subsegment}
    end
  end
end
