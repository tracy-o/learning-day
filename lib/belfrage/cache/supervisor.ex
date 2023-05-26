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
      {Cachex, name: :cache, limit: cachex_limit(), stats: true},
      {Belfrage.Cache.PreflightMetadata, Belfrage.Cache.PreflightMetadata.options()}
    ]
  end

  defp cachex_limit(conf \\ Application.get_env(:cachex, :limit))

  defp cachex_limit(size: size, policy: policy, reclaim: reclaim, options: options) do
    {:limit, size, policy, reclaim, options}
  end
end
