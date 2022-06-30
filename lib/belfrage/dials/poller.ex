defmodule Belfrage.Dials.Poller do
  @moduledoc """
  Periodically read the dials file and updates the dials with its contents
  """
  use Belfrage.Poller, interval: Application.get_env(:belfrage, :poller_intervals)[:dials]

  require Logger

  @json_codec Application.compile_env!(:belfrage, :json_codec)

  @impl Belfrage.Poller
  def poll() do
    case read_dials() do
      {:ok, dials} ->
        Belfrage.Dials.Supervisor.notify(:dials_changed, dials)

      {:error, reason} ->
        Logger.log(:error, "", %{
          msg: "Unable to read dials",
          reason: reason
        })
    end

    :ok
  end

  def read_dials() do
    file_path = Application.get_env(:belfrage, :dials_location)

    with {:ok, contents} <- File.read(file_path) do
      try do
        {:ok, @json_codec.decode!(contents)}
      rescue
        exception -> {:error, exception}
      end
    end
  end
end
