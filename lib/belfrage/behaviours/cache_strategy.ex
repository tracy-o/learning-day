defmodule Belfrage.Behaviours.CacheStrategy do
  @type freshness :: :stale | :fresh

  @callback store(Belfrage.Struct.t()) :: {:ok, true} | {:ok, false}
  @callback fetch(Belfrage.Struct.t()) :: {:ok, freshness, Belfrage.Struct.Response.t()} | {:ok, :content_not_found}

  def strategies_to_achieve_freshness(accepted_freshness) when is_list(accepted_freshness) do
    case :stale in accepted_freshness do
      true -> [Local]
      false -> [Local, DistributedFallback]
    end
  end
end
