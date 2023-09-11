defmodule Belfrage.Cache.Supervisor do
  use Supervisor, restart: :temporary

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    Supervisor.init(children(opts), strategy: :one_for_one, max_restarts: 40)
  end

  defp children(_opts) do
    [
      {Cachex, name: :cache, limit: get_limit_config(config()), stats: true},
      {Belfrage.Cache.PreflightMetadata, Belfrage.Cache.PreflightMetadata.options()}
    ]
  end

  defp config(), do: Application.get_env(:belfrage, :cache)

  def get_limit_config(config) do
    opts = config[:limit]

    size =
      calc_cache_size(
        opts[:size],
        opts[:average_entry_size_kb],
        opts[:ram_allocated]
      )

    {:limit, size, opts[:policy], opts[:reclaim], opts[:options]}
  end

  defp calc_cache_size(nil, entry_size_kb, ram_allocated) do
    ram_kb = :memsup.get_system_memory_data()[:total_memory] / 1024
    round(ram_kb * ram_allocated / entry_size_kb)
  end

  defp calc_cache_size(size, _entry_size_kb, _ram_allocated), do: size
end
