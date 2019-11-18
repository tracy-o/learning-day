defmodule Belfrage.Xray do
  @type segment :: AwsExRay.Segment.t()
  @type trace :: AwsExRay.Trace.t()
  @type app_name :: String.t()

  @callback new_trace() :: trace
  @callback start_tracing(trace, app_name) :: segment
  @callback finish_tracing(segment) :: any()

  defdelegate new_trace, to: AwsExRay.Trace, as: :new
  defdelegate start_tracing(trace, app_name), to: AwsExRay, as: :start_tracing
  defdelegate finish_tracing(segment), to: AwsExRay, as: :finish_tracing
end