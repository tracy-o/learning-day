defmodule Belfrage.Cache.Cleaner do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: :local_cache_cleaner)
  end

  def init(init_state) do
    schedule_work(mem_used_percent())
    {:ok, init_state}
  end

  def handle_info(:refresh, state) do
    clean_cache(mem_used_percent())
    schedule_work(mem_used_percent())
    {:noreply, state}
  end

  # Catch all to handle unexpected messages
  # https://elixir-lang.org/getting-started/mix-otp/genserver.html#call-cast-or-info
  def handle_info(_any_message, state) do
    {:noreply, state}
  end

  # Danger close! clean everything older than 1 hour
  def clean_cache(mem) when mem >= 95 do
    :ets.select_delete(:cache, filter_older_than(:timer.hours(1)))
  end

  def clean_cache(mem) when mem >= 90 do
    :ets.select_delete(:cache, filter_older_than(:timer.hours(5)))
  end

  # don't clean the cache when we still have room
  def clean_cache(_), do: 0

  defp filter_older_than(age) do
    Cachex.Query.raw({:<, :"$2", Belfrage.Timer.now_ms() - age}, true)
  end

  defp mem_used_percent do
    memory_data = :memsup.get_system_memory_data()
    memory_data[:free_memory] / memory_data[:total_memory] * 100
  end

  defp schedule_work(mem) when mem >= 90, do: Process.send_after(self(), :refresh, 1_000)
  defp schedule_work(mem) when mem >= 70, do: Process.send_after(self(), :refresh, 3_000)
  defp schedule_work(mem) when mem >= 50, do: Process.send_after(self(), :refresh, 10_000)
  defp schedule_work(_mem), do: Process.send_after(self(), :refresh, 60_000)
end
