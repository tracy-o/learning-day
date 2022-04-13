defmodule Belfrage.Dials.Poller do
  @moduledoc """
  Periodically read the dials file and updates the dials with its contents
  """
  require Logger

  use GenServer

  @json_codec Application.get_env(:belfrage, :json_codec)
  @startup_polling_delay Application.get_env(:belfrage, :dials_startup_polling_delay)
  @polling_interval 5_000

  def start_link(opts) do
    opts =
      opts
      |> Keyword.put_new(:startup_polling_delay, @startup_polling_delay)
      |> Keyword.put_new(:polling_interval, @polling_interval)

    GenServer.start_link(__MODULE__, opts, name: Keyword.get(opts, :name, __MODULE__))
  end

  @impl GenServer
  def init(opts) do
    opts
    |> Keyword.fetch!(:startup_polling_delay)
    |> schedule_polling()

    {:ok, opts}
  end

  @impl GenServer
  def handle_info(:poll, opts) do
    opts
    |> Keyword.fetch!(:polling_interval)
    |> schedule_polling()

    case read_dials() do
      {:ok, dials} ->
        Belfrage.Dials.Supervisor.notify(:dials_changed, dials)

      {:error, reason} ->
        Logger.log(:error, "Unable to read dials", %{
          reason: reason
        })
    end

    {:noreply, opts}
  end

  defp schedule_polling(delay) do
    Process.send_after(self(), :poll, delay)
  end

  def read_dials() do
    file_path = Application.get_env(:belfrage, :dials_location)

    with {:ok, contents} <- File.read(file_path) do
      @json_codec.decode(contents)
    end
  end
end
