defmodule Belfrage.GenServerMonitor do
  use GenServer

  @event Application.get_env(:belfrage, :event)
  @servers Application.get_env(:belfrage, :servers_to_monitor)
  @refresh_rate 5_000

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: Belfrage.GenServerMonitor)
  end

  def init(_opts) do
    send(self(), :refresh)
    {:ok, %{servers: @servers}}
  end

  def handle_info(:refresh, state) do
    for server_name <- state.servers do
      case queue_length(server_name) do
        {:ok, len} -> send_metric(server_name, len)
        :error -> nil
      end
    end

    Process.send_after(__MODULE__, :refresh, @refresh_rate)
    {:noreply, state}
  end

  defp queue_length(process_name) do
    pid = Process.whereis(process_name)

    case pid do
      nil -> :error
      _ -> Process.info(pid) |> Keyword.fetch(:message_queue_len)
    end
  end

  defp send_metric(server_name, len) do
    name =
      Atom.to_string(server_name)
      |> String.split(".")
      |> List.last()

    @event.record(:metric, :gauge, "gen_server.#{name}.queue_length", value: len)
  end
end
