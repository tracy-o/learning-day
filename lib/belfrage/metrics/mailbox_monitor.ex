defmodule Belfrage.Metrics.MailboxMonitor do
  use GenServer, restart: :temporary

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
      case mailbox_size(server_name) do
        nil -> log_failure(server_name)
        len -> send_metric(server_name, len)
      end
    end

    Process.send_after(self(), :refresh, rate)
    {:noreply, state}
  end

  def handle_info(_msg, state), do: {:noreply, state}

  defp mailbox_size(server_name) do
    with pid when not is_nil(pid) <- Process.whereis(server_name),
         {:message_queue_len, len} <- Process.info(pid, :message_queue_len),
         do: len
  end

  defp log_failure(server_name) do
    @event.record(:log, :error, %{
      msg: "Error retrieving the mailbox size for #{server_name}, pid could not be found"
    })
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
