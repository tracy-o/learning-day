defmodule Belfrage.Xray do
  alias AwsExRay.Trace
  alias AwsExRay.Segment
  alias AwsExRay.Subsegment
  alias AwsExRay.Client
  alias AwsExRay.Record.{HTTPResponse, HTTPRequest, Error}

  @type name :: String.t()
  @type annotations :: map()
  @type metadata :: map()
  @type request_info :: %{method: String.t(), path: String.t()}
  @type response_info :: %{
          status: non_neg_integer(),
          content_length: non_neg_integer()
        }

  @spec start_tracing(name) :: Segment.t()
  def start_tracing(name) do
    Trace.new()
    |> Segment.new(name)
  end

  @spec start_subsegment(Trace.t(), name) :: Subsegment.t()
  def start_subsegment(segment = %Segment{}, name) do
    if_sampled(segment, fn ->
      Subsegment.new(%{segment.trace | parent: segment.id}, name, :none)
    end)
  end

  @spec set_start_time(Subsegment.t(), float()) :: Subsegment.t()
  def set_start_time(subsegment = %Subsegment{}, start_time) do
    Subsegment.set_start_time(subsegment, start_time)
  end

  @spec add_annotations(Segment.t(), annotations) :: Segment.t()
  def add_annotations(segment = %Segment{}, annotations) do
    if_sampled(segment, fn -> Segment.add_annotations(segment, annotations) end)
  end

  @spec add_annotations(Subsegment.t(), annotations) :: Subsegment.t()
  def add_annotations(subsegment = %Subsegment{}, annotations) do
    if_sampled(subsegment, fn -> Subsegment.add_annotations(subsegment, annotations) end)
  end

  @spec add_struct_annotations(Segment.t(), struct) :: Segment.t()
  def add_struct_annotations(segment = %Segment{}, struct) do
    add_annotations(segment, struct_annotations(struct))
  end

  @spec add_struct_annotations(Subsegment.t(), struct) :: Subsegment.t()
  def add_struct_annotations(subsegment = %Subsegment{}, struct) do
    add_annotations(subsegment, struct_annotations(struct))
  end

  @spec add_metadata(Segment.t(), metadata) :: Segment.t()
  def add_metadata(segment = %Segment{}, metadata) do
    metadata = Map.merge(segment.metadata, metadata)
    Map.put(segment, :metadata, metadata)
  end

  @spec add_metadata(Subsegment.t(), metadata) :: Subsegment.t()
  def add_metadata(subsegment = %Subsegment{}, metadata) do
    metadata = Map.merge(subsegment.segment.metadata, metadata)
    put_in(subsegment.segment.metadata, metadata)
  end

  @spec set_http_request(Segment.t(), request_info) :: Segment.t()
  def set_http_request(segment = %Segment{}, %{method: method, path: url}) do
    if_sampled(segment, fn ->
      Segment.set_http_request(segment, %HTTPRequest{
        segment_type: :segment,
        method: method,
        url: url
      })
    end)
  end

  @spec set_http_request(Subsegment.t(), request_info) :: Subsegment.t()
  def set_http_request(subsegment = %Subsegment{}, %{method: method, path: url}) do
    if_sampled(subsegment, fn ->
      Subsegment.set_http_request(subsegment, %HTTPRequest{
        segment_type: :subsegment,
        method: method,
        url: url
      })
    end)
  end

  @spec set_http_response(Segment.t(), response_info) :: Segment.t()
  def set_http_response(segment = %Segment{}, %{status: status, content_length: length}) do
    if_sampled(segment, fn ->
      segment
      |> Segment.set_http_response(%HTTPResponse{status: status, length: length})
      |> Segment.set_error(%Error{
        error: status in 400..499,
        fault: status >= 500,
        throttle: status == 429
      })
    end)
  end

  @spec set_http_response(Subsegment.t(), response_info) :: Subsegment.t()
  def set_http_response(subsegment = %Subsegment{}, %{status: status, content_length: length}) do
    if_sampled(subsegment, fn ->
      subsegment
      |> Subsegment.set_http_response(%HTTPResponse{status: status, length: length})
      |> Subsegment.set_error(%Error{
        error: status in 400..499,
        fault: status >= 500,
        throttle: status == 429
      })
    end)
  end

  @spec finish(Segment.t()) :: Segment.t()
  def finish(segment = %Segment{}) do
    if_sampled(segment, fn -> Segment.finish(segment) end)
  end

  @spec finish(Subsegment.t()) :: Subsegment.t()
  def finish(subsegment = %Subsegment{}) do
    if_sampled(subsegment, fn -> Subsegment.finish(subsegment) end)
  end

  @spec finish(Subsegment.t(), float()) :: Subsegment.t()
  def finish(subsegment = %Subsegment{}, end_time) do
    if_sampled(subsegment, fn -> Subsegment.finish(subsegment, end_time) end)
  end

  @spec send(Segment.t() | Subsegment.t(), module) :: :ok
  def send(some_segment, client \\ Client)

  def send(segment = %Segment{}, client) do
    if_sampled(segment, fn ->
      segment
      |> Segment.to_json()
      |> client.send()
    end)
  end

  def send(subsegment = %Subsegment{}, client) do
    if_sampled(subsegment, fn ->
      subsegment
      |> Subsegment.to_json()
      |> client.send()
    end)
  end

  @spec build_trace_id_header(Segment.t()) :: String.t()
  def build_trace_id_header(segment) do
    sampled_value = if segment.trace.sampled, do: '1', else: '0'

    "Root=" <> segment.trace.root <> ";Parent=" <> segment.id <> ";Sampled=#{sampled_value}"
  end

  defp if_sampled(trace = %Trace{}, func) do
    if trace.sampled do
      func.()
    else
      trace
    end
  end

  defp if_sampled(segment = %Segment{}, func) do
    if segment.trace.sampled do
      func.()
    else
      segment
    end
  end

  defp if_sampled(subsegment = %Subsegment{}, func) do
    if subsegment.segment.trace.sampled do
      func.()
    else
      subsegment
    end
  end

  defp struct_annotations(struct) do
    %{
      "owner" => struct.private.owner,
      "route_state_id" => struct.private.route_state_id,
      "preview_mode" => struct.private.preview_mode,
      "production_environment" => struct.private.production_environment,
      "runbook" => struct.private.runbook
    }
  end
end
