defmodule Belfrage.XrayTest do
  use ExUnit.Case, async: true
  use Belfrage.Test.XrayHelper

  alias Belfrage.Xray
  alias Belfrage.Struct
  alias Belfrage.Struct.Private

  alias AwsExRay.Segment
  alias AwsExRay.Trace
  alias AwsExRay.Subsegment
  alias AwsExRay.Record.{HTTPRequest, HTTPResponse, Error}

  @test_struct %Struct{
    private: %Private{
      owner: "me!",
      route_state_id: "some_id",
      preview_mode: "off",
      production_environment: "test",
      runbook: "https://some.runbook/url"
    }
  }

  test "a segment is created by start_tracing" do
    assert %Segment{
             name: "test_name"
           } = Xray.start_tracing("test_name")
  end

  describe "a segment when being sampled" do
    setup do
      %{segment: build_segment(sampled: true)}
    end

    test "can be annotated", %{segment: segment} do
      segment = Xray.add_annotations(segment, %{hello: "there"})
      assert segment.annotation == %{hello: "there"}
    end

    test "can be annotated with a struct", %{segment: segment} do
      segment = Xray.add_struct_annotations(segment, @test_struct)

      assert segment.annotation == %{
               "owner" => "me!",
               "route_state_id" => "some_id",
               "preview_mode" => "off",
               "production_environment" => "test",
               "runbook" => "https://some.runbook/url"
             }
    end

    test "can have metadata added", %{segment: segment} do
      segment = Xray.add_metadata(segment, %{some: :metadata})

      assert segment.metadata == %{
               some: :metadata,
               tracing_sdk: %{name: "aws-ex-ray", version: "0.0.1"}
             }
    end

    test "can set http request information", %{segment: segment} do
      segment = Xray.set_http_request(segment, %{method: "GET", path: "/some/path"})

      assert segment.http.request == %HTTPRequest{
               segment_type: :segment,
               method: "GET",
               url: "/some/path"
             }
    end

    test "can set http response information with different statuses", %{segment: segment} do
      segment_with_status = fn status ->
        Xray.set_http_response(segment, %{status: status, content_length: 10})
      end

      http_response = fn status ->
        %HTTPResponse{
          status: status,
          length: 10
        }
      end

      assert segment_with_status.(200).http.response == http_response.(200)
      assert segment_with_status.(200).error == %Error{}

      assert segment_with_status.(404).http.response == http_response.(404)
      assert segment_with_status.(404).error == %Error{error: true}

      assert segment_with_status.(500).http.response == http_response.(500)

      assert segment_with_status.(500).error == %Error{
               fault: true
             }

      assert segment_with_status.(429).http.response == http_response.(429)

      assert segment_with_status.(429).error == %Error{
               error: true,
               throttle: true
             }
    end

    test "can be finished", %{segment: segment} do
      segment = Xray.finish(segment)
      assert segment.end_time > 0
    end

    test "can be sent", %{segment: segment} do
      Xray.send(segment, MockXrayClient)

      assert_received {:mock_xray_client_data, json_string}
      json = Jason.decode!(json_string)

      assert json["trace_id"]
      assert json["name"] == "test_segment"
    end
  end

  describe "a segment not being sampled " do
    setup do
      %{segment: build_segment(sampled: false)}
    end

    test "can't start a subsegment", %{segment: segment} do
      assert segment == Xray.start_subsegment(segment, "some_subsegment")
    end

    test "can't be annotated", %{segment: segment} do
      assert segment == Xray.add_annotations(segment, %{hello: "there"})
    end

    test "can't be a annotated with a struct", %{segment: segment} do
      assert segment == Xray.add_struct_annotations(segment, @test_struct)
    end

    test "can't set http request information", %{segment: segment} do
      assert segment == Xray.set_http_request(segment, %{method: "GET", path: "/some/path"})
    end

    test "can't set http response information", %{segment: segment} do
      assert segment == Xray.set_http_response(segment, %{status: 200, content_length: 10})
    end

    test "can't be finished", %{segment: segment} do
      assert segment == Xray.finish(segment)
    end

    test "can't be sent", %{segment: segment} do
      Xray.send(segment, MockXrayClient)
      refute_receive {:mock_xray_client_data, _data}
    end
  end

  describe "a subsegment" do
    setup do
      trace = build_segment(sampled: true).trace
      subsegment = Subsegment.new(trace, "test_subsegment")
      %{subsegment: subsegment}
    end

    test "which has been started, contains a the id of its parent segment" do
      parent_segment = build_segment(sampled: true)
      subsegment = Xray.start_subsegment(parent_segment, "test_subsegment")
      assert subsegment.segment.trace.parent == parent_segment.id
    end

    test "can be annotated", %{subsegment: subsegment} do
      subsegment = Xray.add_annotations(subsegment, %{hello: "there"})
      assert subsegment.segment.annotation == %{hello: "there"}
    end

    test "can be annotated with a struct", %{subsegment: subsegment} do
      subsegment = Xray.add_struct_annotations(subsegment, @test_struct)

      assert subsegment.segment.annotation == %{
               "owner" => "me!",
               "route_state_id" => "some_id",
               "preview_mode" => "off",
               "production_environment" => "test",
               "runbook" => "https://some.runbook/url"
             }
    end

    test "can set http request information", %{subsegment: subsegment} do
      subsegment = Xray.set_http_request(subsegment, %{method: "GET", path: "/some/path"})

      assert subsegment.segment.http.request == %HTTPRequest{
               segment_type: :subsegment,
               method: "GET",
               url: "/some/path"
             }
    end

    test "can set http response information with different statuses", %{subsegment: subsegment} do
      subsegment_with_status = fn status ->
        Xray.set_http_response(subsegment, %{status: status, content_length: 10})
      end

      http_response = fn status ->
        %HTTPResponse{
          status: status,
          length: 10
        }
      end

      assert subsegment_with_status.(200).segment.http.response == http_response.(200)
      assert subsegment_with_status.(200).segment.error == %Error{}

      assert subsegment_with_status.(404).segment.http.response == http_response.(404)
      assert subsegment_with_status.(404).segment.error == %Error{error: true}

      assert subsegment_with_status.(500).segment.http.response == http_response.(500)

      assert subsegment_with_status.(500).segment.error == %Error{
               fault: true
             }

      assert subsegment_with_status.(429).segment.http.response == http_response.(429)

      assert subsegment_with_status.(429).segment.error == %Error{
               error: true,
               throttle: true
             }
    end

    test "can be finished", %{subsegment: subsegment} do
      subsegment = Xray.finish(subsegment)
      assert subsegment.segment.end_time > 0
    end

    test "can be sent", %{subsegment: subsegment} do
      Xray.send(subsegment, MockXrayClient)

      assert_received {:mock_xray_client_data, json_string}
      json = Jason.decode!(json_string)

      assert json["trace_id"]
      assert json["name"] == "test_subsegment"
    end
  end
end
