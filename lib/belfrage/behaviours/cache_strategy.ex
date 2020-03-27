defmodule Belfrage.Behaviours.CacheStrategy do
  @type freshness :: :stale | :fresh

  @callback store(Belfrage.Struct.t()) :: {:ok, true} | {:ok, false}
  @callback fetch(Belfrage.Struct.t()) :: {:ok, freshness, Belfrage.Struct.Response.t()} | {:ok, :content_not_found}
  @callback metric_identifier() :: String.t()
end
