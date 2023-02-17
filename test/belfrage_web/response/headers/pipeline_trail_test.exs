defmodule BelfrageWeb.Response.Headers.PipelineTrailTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.Response.Headers.PipelineTrail
  alias Belfrage.Envelope

  describe "when pipeline trails exist in envelope" do
    @envelope %Envelope{
      private: %Envelope.Private{production_environment: "test"},
      debug: %Envelope.Debug{
        pre_flight_pipeline_trail: ["SomePlatformSelector"],
        request_pipeline_trail: ["CircuitBreaker", "HttpRedirector"],
        response_pipeline_trail: ["CacheDirective"]
      }
    }

    test "production_environment is not live" do
      input_conn = conn(:get, "/")
      output_conn = PipelineTrail.add_header(input_conn, @envelope)
      assert_trail_headers(output_conn, ["SomePlatformSelector"], ["CircuitBreaker,HttpRedirector"], ["CacheDirective"])
    end

    test "production_environment is live" do
      envelope = %Envelope{@envelope | private: %Envelope.Private{production_environment: "live"}}
      input_conn = conn(:get, "/")
      output_conn = PipelineTrail.add_header(input_conn, envelope)
      assert_trail_headers(output_conn, [], [], [])
    end
  end

  describe "when pipeline trails are nil" do
    @envelope %Envelope{private: %Envelope.Private{route_state_id: nil}}

    test "pipeline trail headers are not set" do
      input_conn = conn(:get, "/")
      output_conn = PipelineTrail.add_header(input_conn, @envelope)
      assert_trail_headers(output_conn, [], [], [])
    end
  end

  defp assert_trail_headers(conn, pre_flight_trail_res, req_trail_res, resp_trail_res) do
    assert get_resp_header(conn, "belfrage-pre-flight-pipeline-trail") == pre_flight_trail_res
    assert get_resp_header(conn, "belfrage-request-pipeline-trail") == req_trail_res
    assert get_resp_header(conn, "belfrage-response-pipeline-trail") == resp_trail_res
  end
end
