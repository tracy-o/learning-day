defmodule Belfrage.CacheControl do
  @enforce_keys [:cacheability]
  defstruct @enforce_keys ++ [:max_age, :stale_if_error, :stale_while_revalidate]

  def private() do
    %__MODULE__{cacheability: "private"}
  end
end
