defmodule Belfrage.NonEssentialSupervisor do
  use Supervisor, restart: :temporary

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(args) do
    Supervisor.init(children(args), strategy: :one_for_one)
  end

  defp children(env: env) do
    default_children() ++ background_children(env)
  end

  defp default_children() do
    [
      Belfrage.Metrics.Pool,
      Belfrage.TelemetrySupervisor
    ]
  end

  @doc """
  background_children/1

  Processes which demand work from themselves, are regarded
  as "background" processes. For example these processes might
  use `Process.send_after(self(), :refresh, 5_000)`.

  These processes will not be started with the application
  when running the tests. Instead, they will need to be started
  independently in the test setup. For example:
  `start_supervised!(Poller)`
  or
  `start_supervised!({Belfrage.Dials.Supervisor, name: :test_dials_supervisor})`
  https://hexdocs.pm/ex_unit/ExUnit.Callbacks.html#start_supervised!/2

  For more help, see the testing best practices docs
  https://github.com/bbc/belfrage/wiki/Testing-best-practices

  Belfrage.Credentials.Refresh
  - Periodically refreshes AWS tokens.

  Belfrage.MailboxMonitor
  - Monitors the size of the mailbox for gen_servers and reports them
    to CloudWatch
  """
  defp background_children(:test), do: []

  defp background_children(_env) do
    [
      Belfrage.Credentials.Refresh,
      Belfrage.MailboxMonitor
    ]
  end
end
