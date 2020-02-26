defmodule Belfrage.Xray do
  @type segment :: AwsExRay.Segment.t()
  @type trace :: AwsExRay.Trace.t()
  @type app_name :: String.t()

  @callback new_trace() :: trace
  @callback start_tracing(trace, app_name) :: segment
  @callback finish_tracing(segment) :: any()
  @callback start_subsegment(String.t()) :: {:ok, segment} | {:error, String.t()}
  @callback finish_subsegment(segment) :: any()
  @callback set_http_request(segment, %{
              method: String.t(),
              path: String.t()
            }) :: segment
  @callback set_http_response(segment, %{
              status: pos_integer()
            }) :: segment

  alias AwsExRay.Record.{HTTPResponse, HTTPRequest}

  defdelegate new_trace, to: AwsExRay.Trace, as: :new
  defdelegate start_tracing(trace, app_name), to: AwsExRay, as: :start_tracing
  defdelegate finish_tracing(segment), to: AwsExRay, as: :finish_tracing
  defdelegate start_subsegment(segment), to: AwsExRay, as: :start_subsegment
  defdelegate finish_subsegment(segment), to: AwsExRay, as: :finish_subsegment

  def set_http_request(segment, %{method: method, path: path}) do
    segment
    |> AwsExRay.Segment.set_http_request(%HTTPRequest{
      segment_type: :segment,
      method: method,
      url: path
    })
  end

  def set_http_response(segment, %{status: status}) do
    segment
    |> AwsExRay.Segment.set_http_response(%HTTPResponse{
      status: status
    })
  end

  defmacro trace_subsegment(segment_name, do: yield) do
    xray = Application.get_env(:belfrage, :xray)

    quote do
      segment = unquote(xray).start_subsegment(unquote(segment_name))
      result = unquote(yield)

      case segment do
        {:ok, segment} -> unquote(xray).finish_subsegment(segment)
        _ -> :ok
      end

      result
    end
  end
end
