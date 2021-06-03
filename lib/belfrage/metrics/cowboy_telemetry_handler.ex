defmodule Belfrage.Metrics.CowboyTelemetryHandler do
  def setup() do
    events = [
      [:cowboy, :request, :start],
      [:cowboy, :request, :stop],
      [:cowboy, :request, :exception],
      [:cowboy, :request, :early_error]
    ]

    IO.inspect("setup run")

    :telemetry.attach_many(
      "cowboy-telemetry-handler",
      events,
      &handle_event/4,
      nil
    )
  end

  def handle_event([:cowboy, :request, :start], measurements, metadata, _config) do
    IO.inspect("just got a start")
  end

  def handle_event([:cowboy, :request, :stop], measurements, metadata, _config) do
    IO.inspect("just got a stop")
    Belfrage.Metrics.Statix.timing("cowboy.request.duration", Map.get(measurements, :duration))
  end

  def handle_event([:cowboy, :request, :exception], measurements, metadata, _config) do
    IO.inspect("just got an exception")
    Belfrage.Metrics.Statix.increment("cowboy.request.exception")
  end

  def handle_event([:cowboy, :request, :early_error], measurements, metadata, _config) do
    IO.inspect("just got an early error")
    Belfrage.Metrics.Statix.increment("cowboy.request.early_error")
  end
end
