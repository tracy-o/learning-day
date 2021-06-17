defmodule Belfrage.Metrics.MailboxMonitor do
  use GenServer

  @event Application.get_env(:belfrage, :event)
  @servers Application.get_env(:belfrage, :mailbox_monitors)
  @default_refresh_rate Application.get_env(:belfrage, :mailbox_monitor_refresh_rate)

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    rate = Keyword.get(opts, :rate, @default_refresh_rate)
    servers = Keyword.get(opts, :servers, @servers)

    GenServer.start_link(__MODULE__, %{rate: rate, servers: servers}, name: name)
  end

  def init(opts) do
    send(self(), :refresh)
    {:ok, opts}
  end

  def handle_info(:refresh, state = %{rate: rate, servers: servers}) do
    for server_name <- servers do
       case get_pid(server_name) do
        nil -> log_failure(server_name)
        pid -> send_metric(server_name, get_mailbox_size(pid))
      end
    end

    Process.send_after(self(), :refresh, rate)
    {:noreply, state}
  end

  def handle_info(_msg, state), do: {:noreply, state}

  defp get_pid({:loop, loop_name}) do
    GenServer.whereis({:via, Registry, {Belfrage.LoopsRegistry, {Belfrage.Loop, loop_name}}})
  end

  defp get_pid(server_name) do
    Process.whereis(server_name)
  end

  defp get_mailbox_size(pid) do
    pid
    |> Process.info(:message_queue_len)
    |> elem(1)
  end

  defp log_failure({:loop, loop_name}) do
    @event.record(:log, :info, %{
      msg: "Error retrieving the mailbox size for loop #{loop_name}, pid could not be found"
    })
  end

  defp log_failure(server_name) do
    @event.record(:log, :info, %{
      msg: "Error retrieving the mailbox size for #{server_name}, pid could not be found"
    })
  end

  defp send_metric({:loop, loop_name}, len) do
    @event.record(:metric, :gauge, "loop.#{loop_name}.mailbox_size", value: len)
  end

  defp send_metric(server_name, len) do
    name = gen_server_metric_name(server_name)
    @event.record(:metric, :gauge, "gen_server.#{name}.mailbox_size", value: len)
  end

  defp gen_server_metric_name(server_name) do
    Atom.to_string(server_name)
    |> Macro.underscore()
    |> String.trim("elixir/")
  end
end
