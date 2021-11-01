defmodule Belfrage.Xray do
  @type segment :: AwsExRay.Segment.t()
  @type trace :: AwsExRay.Trace.t()
  @type app_name :: String.t()
  @type segment_name :: String.t()

  @callback sampled?(segment) :: boolean()
  @callback start_tracing(app_name) :: {:ok, segment} | {:error, String.t()}
  @callback finish_tracing(segment) :: :ok
  @callback start_subsegment(String.t()) :: {:ok, segment} | {:error, String.t()}
  @callback finish_subsegment(segment) :: :ok
  @callback add_annotations(segment, map) :: segment
  @callback set_http_request(segment, %{
              method: String.t(),
              path: String.t()
            }) :: segment
  @callback set_http_response(segment, %{
              status: pos_integer()
            }) :: segment

  @callback subsegment_with_struct_annotations(segment_name, Belfrage.Struct.t(), (() -> any)) :: any()

  alias AwsExRay.Record.{HTTPResponse, HTTPRequest}

  defdelegate sampled?(segment), to: AwsExRay.Segment, as: :sampled?
  defdelegate add_annotations(segment, map), to: AwsExRay.Segment, as: :add_annotations

  def start_tracing(app_name, xray \\ AwsExRay) do
    try do
      {:ok, xray.start_tracing(app_name)}
    catch
      exception, reason ->
        reason = error_message(exception, reason, "start_tracing/1")

        Belfrage.Event.record(:log, :error, reason)
        {:error, reason}
    end
  end

  def finish_tracing(segment, xray \\ AwsExRay) do
    try do
      :ok = xray.finish_tracing(segment)
    catch
      exception, reason ->
        reason = error_message(exception, reason, "finish_tracing/1")
        Belfrage.Event.record(:log, :error, reason)

        :ok
    end
  end

  def start_subsegment(name, xray \\ AwsExRay) do
    try do
      {:ok, _subsegment} = xray.start_subsegment(name)
    catch
      exception, reason ->
        reason = error_message(exception, reason, "start_subsegment/1")

        Belfrage.Event.record(:log, :error, reason)
        {:error, reason}
    end
  end

  def finish_subsegment(subsegment, xray \\ AwsExRay) do
    try do
      :ok = xray.finish_subsegment(subsegment)
    catch
      exception, reason ->
        reason = error_message(exception, reason, "finish_subsegment/1")
        Belfrage.Event.record(:log, :error, reason)

        :ok
    end
  end

  def set_http_request(segment, %{method: method, path: path}) do
    segment
    |> AwsExRay.Segment.set_http_request(%HTTPRequest{
      segment_type: :segment,
      method: method,
      url: path
    })
  end

  def set_http_response(segment, %{status: status, content_length: content_length}) do
    segment
    |> AwsExRay.Segment.set_http_response(%HTTPResponse{
      status: status,
      length: content_length
    })
    |> AwsExRay.Segment.set_error(%AwsExRay.Record.Error{
      error: status in [400..499],
      fault: status >= 500,
      throttle: status == 429
    })
  end

  def subsegment_with_struct_annotations(subsegment_name, struct = %Belfrage.Struct{}, func) do
    opts = [namespace: :none]

    AwsExRay.subsegment(
      subsegment_name,
      %{
        "owner" => struct.private.owner,
        "loop_id" => struct.private.loop_id,
        "preview_mode" => struct.private.preview_mode,
        "production_environment" => struct.private.production_environment,
        "runbook" => struct.private.runbook
      },
      opts,
      fn _trace_value -> func.() end
    )
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

  defp error_message(:error, reason, function_name) do
    "AwsExRay.#{function_name} errored with reason: #{inspect(reason)}"
  end

  defp error_message(:exit, reason, function_name) do
    "AwsExRay.#{function_name} exited with reason: #{inspect(reason)}"
  end

  defp error_message(:throw, value, function_name) do
    "AwsExRay.#{function_name} unexpectedly threw value: #{inspect(value)}"
  end
end
