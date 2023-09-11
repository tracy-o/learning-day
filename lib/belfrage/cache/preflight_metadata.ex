defmodule Belfrage.Cache.PreflightMetadata do
  require Cachex.Spec
  alias Belfrage.Cache.Supervisor, as: CacheSup

  @table_name :preflight_metadata_cache

  def child_spec(arg) do
    %{
      id: Belfrage.Cache.PreflightMetadata,
      start: {Cachex, :start_link, [arg]}
    }
  end

  def get(cache_prefix, path) do
    case Cachex.get(@table_name, {cache_prefix, path}) do
      {:ok, metadata} when not is_nil(metadata) ->
        :telemetry.execute([:preflight, :cache, :get], %{}, %{preflight_service: cache_prefix, type: "hit"})
        {:ok, metadata}

      _ ->
        :telemetry.execute([:preflight, :cache, :get], %{}, %{preflight_service: cache_prefix, type: "miss"})
        {:error, :preflight_data_not_found}
    end
  end

  def put(cache_prefix, path, metadata) do
    :telemetry.execute([:preflight, :cache, :put], %{}, %{preflight_service: cache_prefix})
    Cachex.put(@table_name, {cache_prefix, path}, metadata)
  end

  def options() do
    config = Application.get_env(:belfrage, :preflight_metadata_cache)

    [
      name: @table_name,
      limit: CacheSup.get_limit_config(config),
      stats: true,
      expiration:
        Cachex.Spec.expiration(
          default: config[:default_ttl_ms],
          interval: config[:expiration_interval_ms],
          lazy: true
        )
    ]
  end
end
