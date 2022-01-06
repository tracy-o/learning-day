defmodule BelfrageWeb.Response.Headers.PipelineTrailTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.Response.Headers.PipelineTrail
  alias Belfrage.Struct

  describe "when pipeline trail exists in struct and production_environment is not live" do
    test "the pipeline trail header is set" do
      input_conn = conn(:get, "/")

      struct = %Struct{
        private: %Struct.Private{production_environment: "test"},
        debug: %Struct.Debug{pipeline_trail: ["CircuitBreaker", "HttpRedirector"]}
      }

      output_conn = PipelineTrail.add_header(input_conn, struct)

      assert get_resp_header(output_conn, "belfrage-pipeline-trail") == ["CircuitBreaker,HttpRedirector"]
    end
  end

  describe "when pipeline trail exists in struct and production_environment is live" do
    test "the pipeline trail header is not set" do
      input_conn = conn(:get, "/")

      struct = %Struct{
        private: %Struct.Private{production_environment: "live"},
        debug: %Struct.Debug{pipeline_trail: ["HttpRedirector", "CircuitBreaker"]}
      }

      output_conn = PipelineTrail.add_header(input_conn, struct)

      assert get_resp_header(output_conn, "belfrage-pipeline-trail") == []
    end
  end

  describe "when pipeline trail is nil" do
    test "the pipeline_trail header is not set" do
      input_conn = conn(:get, "/")
      struct = %Struct{private: %Struct.Private{loop_id: nil}}
      output_conn = PipelineTrail.add_header(input_conn, struct)

      assert get_resp_header(output_conn, "belfrage-pipeline-trail") == []
    end
  end
end
