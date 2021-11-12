defmodule Belfrage.Metrics.ProcessMessageQueueLength.Supervisor do
  use Supervisor

  alias Belfrage.Metrics.ProcessMessageQueueLength

  @processes [
    :ttl_multiplier,
    :logging_level,
    :cache,
    :cache_janitor,
    :cache_locksmith,
    Belfrage.Metrics.LatencyMonitor,
    Belfrage.Authentication.BBCID,
    Belfrage.Authentication.BBCID.AvailabilityPoller,
    Belfrage.Authentication.JWK,
    Belfrage.Authentication.JWK.Poller,
    Belfrage.Services.Webcore.Credentials,
    Belfrage.Services.Webcore.Credentials.Poller
  ]

  @loops ~w(
    NewsArticlePage
    WorldServiceMundo
    FablData
  )

  @interval :timer.seconds(5)

  def start_link(_arg) do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @impl true
  def init(_arg) do
    Supervisor.init([poller(), metrics()], strategy: :one_for_one)
  end

  defp poller() do
    measurements =
      Enum.map(@processes, fn name ->
        {:process_info, name: name, event: [:belfrage, :process_message_queue_length], keys: [:message_queue_len]}
      end)

    measurements =
      measurements ++
        Enum.map(@loops, fn name ->
          {ProcessMessageQueueLength, :track_loop_message_queue_length, [name]}
        end)

    {:telemetry_poller,
     [measurements: measurements, period: @interval, name: :belfrage_process_message_queue_length_poller]}
  end

  defp metrics() do
    metrics =
      Enum.map(@processes, fn name ->
        metric_name =
          name
          |> Atom.to_string()
          |> Macro.underscore()
          |> String.trim("elixir/")

        Telemetry.Metrics.last_value("gen_server.#{metric_name}.mailbox_size",
          event_name: [:belfrage, :process_message_queue_length],
          measurement: :message_queue_len,
          keep: &(&1.name == name)
        )
      end)

    metrics =
      metrics ++
        Enum.map(@loops, fn name ->
          Telemetry.Metrics.last_value("loop.#{name}.mailbox_size",
            event_name: [:belfrage, :loop_message_queue_length],
            measurement: :message_queue_len,
            keep: &(&1.name == name)
          )
        end)

    {TelemetryMetricsStatsd, metrics: metrics}
  end
end
