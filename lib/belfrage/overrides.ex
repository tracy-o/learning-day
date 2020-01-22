defmodule Belfrage.Overrides do
  alias Belfrage.Struct
  @override_keys ["belfrage-cache-bust"]

  def keys, do: @override_keys

  def should_cache_bust?(struct = %Struct{}) do
    Map.has_key?(struct.private.overrides, "belfrage-cache-bust")
  end
end
