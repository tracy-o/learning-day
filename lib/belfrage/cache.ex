defmodule Belfrage.Cache do
  defdelegate store(envelope), to: Belfrage.Cache.Store

  defdelegate fetch(envelope, accepted_freshness, opts \\ []), to: Belfrage.Cache.Fetch
end
