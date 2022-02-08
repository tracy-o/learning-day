defmodule Belfrage.Xray.Telemetry do
  alias Belfrage.Xray

  def setup() do
    events = [
      ~w(belfrage webcore request stop)a
    ]

    :telemetry.attach_many("belfrage-xray", events, &handle_event/4, nil)
  end

  def handle_event(_event, measurements, metadata, _config) do
    segment = get_segment(metadata)

    start_time = format_time(Map.get(measurements, :start_time))
    duration = format_time(Map.get(measurements, :duration))

    subsegment(segment, "webcore-service", start_time, duration, metadata)
    subsegment(segment, "invoke-lambda-call", start_time, duration, metadata)
  end

  defp subsegment(segment, name, start_time, duration, metadata) do
    struct = Map.get(metadata, :struct)
    client = Map.get(metadata, :client, AwsExRay.Client)

    if segment.trace.sampled do
      Xray.start_subsegment(segment, name)
      |> maybe_add_struct_annotations(struct)
      |> Xray.set_start_time(start_time)
      |> Xray.finish(start_time + duration)
      |> Xray.send(client)
    end
  end

  defp format_time(timing) do
    timing / 1_000_000_000
  end

  defp maybe_add_struct_annotations(subsegment, struct) do
    if struct do
      Xray.add_struct_annotations(subsegment, struct)
    else
      subsegment
    end
  end

  defp get_segment(metadata) do
    Map.get(metadata, :struct).request.xray_segment
  end
end
