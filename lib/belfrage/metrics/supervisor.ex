defmodule Belfrage.Metrics.Supervisor do
  use Supervisor, restart: :temporary

  alias Belfrage.Metrics.CowboyTelemetryHandler

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(args) do
    Belfrage.Metrics.CowboyTelemetryHandler.setup()

    Supervisor.init(children(args), strategy: :one_for_one, max_restarts: 10)
  end

  defp children(env: :test) do
    [
      Belfrage.Metrics.MailboxMonitor
    ]
  end

  defp children(_env) do
    [
      Belfrage.Metrics.MailboxMonitor,
      Belfrage.Metrics.Pool,
      Belfrage.Metrics.TelemetrySupervisor,
      Belfrage.Metrics.LatencyMonitor
    ]
  end
end
