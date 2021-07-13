defmodule Belfrage.ProcessorTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  import ExUnit.CaptureLog
  import Belfrage.Test.CachingHelper

  alias Belfrage.{Processor, Struct}
  alias Belfrage.Struct.{Request, Response, Private}

  describe "Processor.get_loop/1" do
    @struct %Struct{private: %Private{loop_id: "SportVideos"}}

    test "adds loop information to Struct.private" do
      assert %Struct{
               request: _request,
               private: %Private{
                 loop_id: "SportVideos",
                 origin: origin,
                 counter: counter,
                 pipeline: pipeline
               }
             } = Processor.get_loop(@struct)

      assert origin != nil, "Expected an origin value to be provided by the loop"
      assert counter != nil, "Expected a counter value to be provided by the loop"
      assert pipeline != nil, "Expected a pipeline value to be provided by the loop"
    end

    test "keeps Struct.Private default values when merging in routespec data" do
      assert %Struct{
               request: _request,
               private: %Private{
                 cookie_allowlist: cookie_allowlist
               }
             } = Processor.get_loop(@struct)

      assert cookie_allowlist == []
    end
  end

  describe "Processor.request_pipeline/1" do
    @struct %Struct{
      private: %Private{
        loop_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        counter: %{},
        pipeline: ["MyTransformer1"]
      }
    }

    test "runs struct through transformers" do
      assert %{
               request: _request,
               private: _private,
               sample_change: "foo"
             } = Processor.request_pipeline(@struct)
    end
  end

  describe "Processor.request_pipeline/1 with empty pipeline" do
    @struct %Struct{
      private: %Private{
        loop_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/",
        counter: %{},
        pipeline: []
      }
    }

    test "returns the unmodified struct" do
      assert %{
               request: _request,
               private: _private
             } = Processor.request_pipeline(@struct)
    end
  end

  describe "Processor.init_post_response_pipeline/1" do
    @resp_struct %Struct{
      private: %Private{
        loop_id: "SportVideos",
        origin: "https://origin.bbc.co.uk/"
      },
      response: %Response{body: :zlib.gzip("a response"), http_status: 501}
    }

    test "increments status" do
      Belfrage.LoopsRegistry.find_or_start(@resp_struct)
      Processor.init_post_response_pipeline(@resp_struct)

      assert {:ok,
              %{
                counter: %{"https://origin.bbc.co.uk/" => %{501 => 1, :errors => 1}}
              }} = Belfrage.Loop.state(@resp_struct)
    end
  end

  describe "Processor.response_pipeline/1" do
    @resp_struct %Struct{
      response: %Response{
        http_status: 501,
        body: "",
        headers: %{
          "connection" => "close"
        }
      }
    }

    test "calls the ResponseHeaderGuardian response transformer" do
      result = Processor.response_pipeline(@resp_struct)

      refute Map.has_key?(result.response.headers, "connection")
    end
  end

  describe "Processor.response_pipeline/1 on 404 response" do
    @resp_struct %Struct{
      response: %Response{
        http_status: 404,
        body: "",
        headers: %{
          "connection" => "close"
        }
      }
    }

    test "it should log a 404 error" do
      log_message =
        capture_log(fn ->
          Processor.response_pipeline(@resp_struct)
        end)

      assert String.contains?(log_message, "404 error from origin")
    end
  end

  describe "Process.allowlists/1" do
    test "filters out query params not in the allowlist" do
      struct = %Struct{
        request: %Request{query_params: %{"allowed" => "yes", "not-allowed" => "yes"}},
        private: %Private{query_params_allowlist: ["allowed"]}
      }

      struct = Processor.allowlists(struct)
      assert Map.has_key?(struct.request.query_params, "allowed")
      refute Map.has_key?(struct.request.query_params, "not-allowed")
    end

    test "filters out headers not in the allowlist" do
      struct = %Struct{
        request: %Request{raw_headers: %{"allowed" => "yes", "not-allowed" => "yes"}},
        private: %Private{headers_allowlist: ["allowed"]}
      }

      struct = Processor.allowlists(struct)
      assert Map.has_key?(struct.request.raw_headers, "allowed")
      refute Map.has_key?(struct.request.raw_headers, "not-allowed")
    end

    test "filters out cookies not in the allowlist" do
      struct = %Struct{
        request: %Request{raw_headers: %{"cookie" => "best=bourbon;worst=custard-cream"}},
        private: %Private{cookie_allowlist: ["best"]}
      }

      assert %{"best" => "bourbon"} == Processor.allowlists(struct).request.cookies
    end
  end

  describe "Process.personalisation/1" do
    test "adds personalised: true to a personalised route" do
      struct = %Struct{private: %Struct.Private{loop_id: SomePersonalisedLoop}}

      assert true == Processor.personalisation(struct).private.personalised
    end

    test "adds personalised: false to a non personalised route" do
      struct = %Struct{private: %Struct.Private{loop_id: SomeLoop}}

      assert false == Processor.personalisation(struct).private.personalised
    end
  end

  describe "fetch_early_response_from_cache/1" do
    setup do
      struct = %Struct{request: %Request{request_hash: unique_cache_key()}}
      response = %Response{body: "Cached response", cache_directive: %{max_age: 60}}
      put_into_cache(%Struct{struct | response: response})
      %{struct: struct, cached_response: response}
    end

    test "uses cached response", %{struct: struct, cached_response: cached_response} do
      %{response: response} = Processor.fetch_early_response_from_cache(struct)
      assert response.body == cached_response.body
    end

    test "does not use cached response for personalised requests", %{struct: struct, cached_response: cached_response} do
      struct = Struct.add(struct, :private, %{personalisation: true})
      %{response: response} = Processor.fetch_early_response_from_cache(struct)
      refute response.body == cached_response.body
    end
  end
end
