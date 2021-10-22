defmodule Belfrage.Xray do
  @type segment :: AwsExRay.Segment.t()
  @type trace :: AwsExRay.Trace.t()
  @type app_name :: String.t()
  @type segment_name :: String.t()

  @callback sampled?(segment) :: boolean()
  @callback start_tracing(app_name) :: segment
  @callback finish_tracing(segment) :: any()
  @callback start_subsegment(String.t()) :: {:ok, segment} | {:error, String.t()}
  @callback finish_subsegment(segment) :: any()
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

  def start_tracing(app_name) do
    try do
      {:ok, AwsExRay.start_tracing(app_name)}
    catch
      :error, reason ->
        Belfrage.Event.record(:log, :error, inspect(reason))
        {:error, reason}
    end
  end

  def finish_tracing(segment) do
    try do
      AwsExRay.finish_tracing(segment)
    catch
      :error, reason ->
        Belfrage.Event.record(:log, :error, inspect(reason))
        :ok
    end
  end

  def start_subsegment(name, opts \\ []) do
    try do
      AwsExRay.start_subsegment(name, opts)
    catch
      :error, reason ->
        Belfrage.Event.record(:log, :error, inspect(reason))
        {:error, reason}
    end
  end

  def finish_subsegment(subsegment) do
    try do
      AwsExRay.finish_subsegment(subsegment)
    catch
      :error, reason ->
        Belfrage.Event.record(:log, :error, inspect(reason))
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
end
