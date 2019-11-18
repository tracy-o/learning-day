defmodule Belfrage.XrayStub do
  @behaviour Belfrage.Xray

  def new_trace do
    AwsExRay.Trace.new()
  end

  def start_tracing(trace, _app_name) do
    %AwsExRay.Segment{
      trace: trace
    }
  end

  def finish_tracing(_segment) do
    :ok
  end
end
