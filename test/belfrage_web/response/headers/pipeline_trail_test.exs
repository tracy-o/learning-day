defmodule BelfrageWeb.Response.Headers.PipelineTrailTest do
  use ExUnit.Case
  use Plug.Test

  alias BelfrageWeb.Response.Headers.PipelineTrail
  alias Belfrage.Envelope

  describe "when request pipeline trail exists in envelope and production_environment is not live" do
    test "the request pipeline trail header is set" do
      input_conn = conn(:get, "/")

      envelope = %Envelope{
        private: %Envelope.Private{production_environment: "test"},
        debug: %Envelope.Debug{request_pipeline_trail: ["CircuitBreaker", "HttpRedirector"]}
      }

      output_conn = PipelineTrail.add_header(input_conn, envelope)

      assert get_resp_header(output_conn, "belfrage-request-pipeline-trail") == ["CircuitBreaker,HttpRedirector"]
    end
  end

  describe "when request pipeline trail exists in envelope and production_environment is live" do
    test "the request pipeline trail header is not set" do
      input_conn = conn(:get, "/")

      envelope = %Envelope{
        private: %Envelope.Private{production_environment: "live"},
        debug: %Envelope.Debug{request_pipeline_trail: ["HttpRedirector", "CircuitBreaker"]}
      }

      output_conn = PipelineTrail.add_header(input_conn, envelope)

      assert get_resp_header(output_conn, "belfrage-request-pipeline-trail") == []
    end
  end

  describe "when response pipeline trail exists in envelope and production_environment is not live" do
    test "the request and response pipeline trail header is set" do
      input_conn = conn(:get, "/")

      envelope = %Envelope{
        private: %Envelope.Private{production_environment: "test"},
        debug: %Envelope.Debug{
          request_pipeline_trail: ["CircuitBreaker", "HttpRedirector"],
          response_pipeline_trail: ["CacheDirective"]
        }
      }

      output_conn = PipelineTrail.add_header(input_conn, envelope)

      assert get_resp_header(output_conn, "belfrage-request-pipeline-trail") == ["CircuitBreaker,HttpRedirector"]
      assert get_resp_header(output_conn, "belfrage-response-pipeline-trail") == ["CacheDirective"]
    end
  end

  describe "when response pipeline trail exists in envelope and production_environment is live" do
    test "the response pipeline trail header is not set" do
      input_conn = conn(:get, "/")

      envelope = %Envelope{
        private: %Envelope.Private{production_environment: "live"},
        debug: %Envelope.Debug{
          request_pipeline_trail: ["CircuitBreaker", "HttpRedirector"],
          response_pipeline_trail: ["CacheDirective"]
        }
      }

      output_conn = PipelineTrail.add_header(input_conn, envelope)

      assert get_resp_header(output_conn, "belfrage-response-pipeline-trail") == []
    end
  end

  describe "when request pipeline trail is nil" do
    test "the request pipeline_trail header is not set" do
      input_conn = conn(:get, "/")
      envelope = %Envelope{private: %Envelope.Private{route_state_id: nil}}
      output_conn = PipelineTrail.add_header(input_conn, envelope)

      assert get_resp_header(output_conn, "belfrage-request-pipeline-trail") == []
    end
  end

  describe "when response pipeline trail is nil" do
    test "the response pipeline_trail header is not set" do
      input_conn = conn(:get, "/")
      envelope = %Envelope{private: %Envelope.Private{route_state_id: nil}}
      output_conn = PipelineTrail.add_header(input_conn, envelope)

      assert get_resp_header(output_conn, "belfrage-request-pipeline-trail") == []
    end
  end
end
