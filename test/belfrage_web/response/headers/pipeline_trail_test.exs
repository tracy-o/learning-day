defmodule BelfrageWeb.Response.Headers.PipelineTrailTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.Response.Headers.PipelineTrail
  alias Belfrage.Struct

  describe "when request pipeline trail exists in struct and production_environment is not live" do
    test "the request pipeline trail header is set" do
      input_conn = conn(:get, "/")

      struct = %Struct{
        private: %Struct.Private{production_environment: "test"},
        debug: %Struct.Debug{request_pipeline_trail: ["CircuitBreaker"]}
      }

      output_conn = PipelineTrail.add_header(input_conn, struct)

      assert get_resp_header(output_conn, "belfrage-request-pipeline-trail") == ["CircuitBreaker"]
    end
  end

  describe "when request pipeline trail exists in struct and production_environment is live" do
    test "the request pipeline trail header is not set" do
      input_conn = conn(:get, "/")

      struct = %Struct{
        private: %Struct.Private{production_environment: "live"},
        debug: %Struct.Debug{request_pipeline_trail: ["CircuitBreaker"]}
      }

      output_conn = PipelineTrail.add_header(input_conn, struct)

      assert get_resp_header(output_conn, "belfrage-request-pipeline-trail") == []
    end
  end

  describe "when response pipeline trail exists in struct and production_environment is not live" do
    test "the request and response pipeline trail header is set" do
      input_conn = conn(:get, "/")

      struct = %Struct{
        private: %Struct.Private{production_environment: "test"},
        debug: %Struct.Debug{
          request_pipeline_trail: ["CircuitBreaker"],
          response_pipeline_trail: ["CacheDirective"]
        }
      }

      output_conn = PipelineTrail.add_header(input_conn, struct)

      assert get_resp_header(output_conn, "belfrage-request-pipeline-trail") == ["CircuitBreaker"]
      assert get_resp_header(output_conn, "belfrage-response-pipeline-trail") == ["CacheDirective"]
    end
  end

  describe "when response pipeline trail exists in struct and production_environment is live" do
    test "the response pipeline trail header is not set" do
      input_conn = conn(:get, "/")

      struct = %Struct{
        private: %Struct.Private{production_environment: "live"},
        debug: %Struct.Debug{
          request_pipeline_trail: ["CircuitBreaker"],
          response_pipeline_trail: ["CacheDirective"]
        }
      }

      output_conn = PipelineTrail.add_header(input_conn, struct)

      assert get_resp_header(output_conn, "belfrage-response-pipeline-trail") == []
    end
  end

  describe "when request pipeline trail is nil" do
    test "the request pipeline_trail header is not set" do
      input_conn = conn(:get, "/")
      struct = %Struct{private: %Struct.Private{route_state_id: nil}}
      output_conn = PipelineTrail.add_header(input_conn, struct)

      assert get_resp_header(output_conn, "belfrage-request-pipeline-trail") == []
    end
  end

  describe "when response pipeline trail is nil" do
    test "the response pipeline_trail header is not set" do
      input_conn = conn(:get, "/")
      struct = %Struct{private: %Struct.Private{route_state_id: nil}}
      output_conn = PipelineTrail.add_header(input_conn, struct)

      assert get_resp_header(output_conn, "belfrage-request-pipeline-trail") == []
    end
  end
end
