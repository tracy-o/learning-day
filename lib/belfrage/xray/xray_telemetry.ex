defmodule Belfrage.Xray.Telemetry do
  alias Belfrage.Xray

  def setup() do
    events = [
      ~w(belfrage webcore request stop)a
    ]

    :telemetry.attach_many("belfrage-xray", events, &__MODULE__.handle_event/4, nil)
  end

  def handle_event(_event, measurements, metadata, _config) do
    if segment_in(metadata) do
      segment = metadata.envelope.request.xray_segment
      start_time = format_time(Map.get(measurements, :start_time))
      duration = format_time(Map.get(measurements, :duration))

      subsegment(segment, "webcore-service", start_time, duration, metadata)
      subsegment(segment, "invoke-lambda-call", start_time, duration, metadata)
    end
  end

  defp subsegment(segment, name, start_time, duration, metadata) do
    envelope = Map.get(metadata, :envelope)
    client = Map.get(metadata, :client, AwsExRay.Client)

    if segment.trace.sampled do
      Xray.start_subsegment(segment, name)
      |> maybe_add_envelope_annotations(envelope)
      |> Xray.set_start_time(start_time)
      |> Xray.finish(start_time + duration)
      |> Xray.send(client)
    end
  end

  defp format_time(timing) do
    timing / 1_000_000_000
  end

  defp maybe_add_envelope_annotations(subsegment, envelope) do
    if envelope do
      Xray.add_envelope_annotations(subsegment, envelope)
    else
      subsegment
    end
  end

  defp segment_in(metadata) do
    if Map.get(metadata, :envelope) do
      metadata.envelope.request.xray_segment
    end
  end
end
