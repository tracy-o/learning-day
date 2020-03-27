defmodule CacheStrategyStub do
  @behaviour Belfrage.Behaviours.CacheStrategy

  def store(_struct), do: {:ok, true}
  def fetch(_struct), do: {:ok, :content_not_found}
  def metric_identifier, do: "cache_strategy"
end
