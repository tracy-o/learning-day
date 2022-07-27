defmodule Belfrage.Cache do
  defdelegate store(struct), to: Belfrage.Cache.Store

  defdelegate fetch(struct, accepted_freshness, opts \\ []), to: Belfrage.Cache.Fetch
end
