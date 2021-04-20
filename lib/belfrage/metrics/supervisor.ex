defmodule Belfrage.Metrics.Supervisor do
  use Supervisor

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(args) do
    Supervisor.init(children(args), strategy: :one_for_one, max_restarts: 10)
  end

  defp children(env: :test) do
    [
      Belfrage.MailboxMonitor
    ]
  end

  defp children(_env) do
    [
      Belfrage.MailboxMonitor,
      Belfrage.Metrics.Pool,
      Belfrage.TelemetrySupervisor
    ]
  end
end
