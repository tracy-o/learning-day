defmodule Belfrage.MailboxMonitor do
  use GenServer

  @event Application.get_env(:belfrage, :event)
  @servers Application.get_env(:belfrage, :mailbox_monitors)
  @refresh_rate 30_000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    send(self(), :refresh)
    {:ok, %{servers: @servers}}
  end

  def handle_info(:refresh, state) do
    for server_name <- state.servers do
      case mailbox_size(server_name) do
        nil -> log_failure(server_name)
        len -> send_metric(server_name, len)
      end
    end

    Process.send_after(__MODULE__, :refresh, @refresh_rate)
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
