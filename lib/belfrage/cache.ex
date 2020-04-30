defmodule Belfrage.Cache do
  defdelegate store(struct), to: Belfrage.Cache.Store

  defdelegate fetch(struct, accepted_freshness), to: Belfrage.Cache.Fetch

  def fetch_fallback(struct), do: fetch(struct, [:fresh, :stale])
end
