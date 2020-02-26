defmodule Belfrage.XrayStub do
  @behaviour Belfrage.Xray

  def new_trace do
    %AwsExRay.Trace{
      parent: "",
      root: "1-5dd274e2-00644696c03ec16a784a2e43",
      sampled: false
    }
  end

  def start_tracing(trace, _app_name) do
    %AwsExRay.Segment{
      trace: trace,
      id: "fake-xray-parent-id"
    }
  end

  def set_http_request(segment, _http_request), do: segment
  def set_http_response(segment, _http_response), do: segment

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
