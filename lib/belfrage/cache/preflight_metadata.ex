defmodule Belfrage.Cache.PreflightMetadata do
  require Cachex.Spec

  @table_name :preflight_metadata_cache

  def child_spec(arg) do
    %{
      id: Belfrage.Cache.PreflightMetadata,
      start: {Cachex, :start_link, [arg]}
    }
  end

  def get(cache_prefix, path) do
    :telemetry.execute([:preflight, :cache, :get], %{}, %{preflight_service: cache_prefix})

    case Cachex.get(@table_name, {cache_prefix, path}) do
      {:ok, metadata} when is_binary(metadata) -> {:ok, metadata}
      _ -> {:error, :preflight_data_not_found}
    end
  end

  def put(cache_prefix, path, metadata) do
    :telemetry.execute([:preflight, :cache, :put], %{}, %{preflight_service: cache_prefix})
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
    Application.get_env(:belfrage, :preflight_metadata_cache)
  end

  defp limit(size: size, policy: policy, reclaim: reclaim, options: options) do
    {:limit, size, policy, reclaim, options}
  end
end
