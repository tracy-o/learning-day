defmodule Belfrage.Cache.PreFlightMetadata do
  require Cachex.Spec

  @table_name :pre_flight_metadata_cache

  def child_spec(arg) do
    %{
      id: Belfrage.Cache.PreFlightMetadata,
      start: {Cachex, :start_link, [arg]}
    }
  end

  def get(cache_prefix, path) do
    case Cachex.get(@table_name, {cache_prefix, path}) do
      {:ok, metadata} when is_binary(metadata) -> {:ok, metadata}
      _ -> {:error, :metadata_not_found}
    end
  end

  def put(cache_prefix, path, metadata) do
    Cachex.put(@table_name, {cache_prefix, path}, metadata)
  end

  def options() do
    [
      name: @table_name,
      limit: limit(config()[:limit]),
      stats: true,
      expiration:
        Cachex.Spec.expiration(
          default: config()[:default_ttl_ms],
          interval: config()[:expiration_interval_ms],
          lazy: true
        )
    ]
  end

  defp config() do
    Application.get_env(:belfrage, :pre_flight_metadata_cache)
  end

  defp limit(size: size, policy: policy, reclaim: reclaim, options: options) do
    {:limit, size, policy, reclaim, options}
  end
end
