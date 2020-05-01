defmodule Belfrage.Cache do
  defdelegate store(struct), to: Belfrage.Cache.Store

  defdelegate fetch(struct, accepted_freshness), to: Belfrage.Cache.Fetch

  defdelegate fetch_fallback_on_error(struct), to: Belfrage.Cache.Fetch
end
