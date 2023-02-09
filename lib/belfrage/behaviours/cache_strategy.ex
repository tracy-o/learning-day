defmodule Belfrage.Behaviours.CacheStrategy do
  @type freshness :: :stale | :fresh

  @callback store(Belfrage.Envelope.t()) :: {:ok, true} | {:ok, false}
  @callback fetch(Belfrage.Envelope.t()) :: {:ok, freshness, Belfrage.Envelope.Response.t()} | {:ok, :content_not_found}
  @callback metric_identifier() :: String.t()
end
