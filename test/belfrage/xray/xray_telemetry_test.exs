defmodule Belfrage.Xray.TelemetryTest do
  use ExUnit.Case, async: true
  use Belfrage.Test.XrayHelper
  import Belfrage.Test.MetricsHelper

  alias Belfrage.Xray
  alias Belfrage.Struct
  alias Belfrage.Struct.Private

  @test_struct %Struct{
    private: %Private{
      owner: "me!",
      loop_id: "some_id",
      preview_mode: "off",
      production_environment: "test",
      runbook: "https://some.runbook/url"
    }
  }

  describe "webcore.request metric triggering handle_event/5" do
    setup do
      struct = put_in(@test_struct.request.xray_segment, build_segment(sampled: true))

      Xray.Telemetry.setup()

      Belfrage.Metrics.duration(~w(webcore request)a, %{struct: struct, client: ClientMock}, fn -> Process.sleep(1) end)
      assert_received {:client_mock, webcore_subsegment}
      assert_received {:client_mock, lambda_subsegment}

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

    test "subsegments end_time is after start_time", %{webcore_subsegment: webcore_subsegment, lambda_subsegment: lambda_subsegment} do
      assert webcore_subsegment["end_time"] - webcore_subsegment["start_time"] > 0
      assert lambda_subsegment["end_time"] - lambda_subsegment["start_time"] > 0
    end

    test "webcore subsegment had annotations", %{webcore_subsegment: subsegment} do
      assert subsegment["annotations"]["loop_id"] == "some_id"
    end
  end
end
