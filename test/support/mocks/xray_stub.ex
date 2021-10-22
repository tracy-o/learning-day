defmodule Belfrage.XrayStub do
  @behaviour Belfrage.Xray

  def start_tracing(_app_name) do
    trace = %AwsExRay.Trace{
      parent: "",
      root: "1-5dd274e2-00644696c03ec16a784a2e43",
      sampled: false
    }

    segment = %AwsExRay.Segment{
      trace: trace,
      id: "fake-xray-parent-id"
    }

    {:ok, segment}
  end

  def sampled?(_segment), do: true

  def set_http_request(segment, _http_request), do: segment
  def set_http_response(segment, _http_response), do: segment

  def add_annotations(segment, _annotations), do: segment

  def subsegment_with_struct_annotations(_segment_name, _struct, func), do: func.()

  def finish_tracing(_segment) do
    :ok
  end

  def start_subsegment(_segment_name) do
    {:ok, :segment}
  end

  def finish_subsegment(_segment_name) do
    :ok
  end
end
