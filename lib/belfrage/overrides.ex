defmodule Belfrage.Overrides do
  alias Belfrage.Envelope
  @override_keys ["belfrage-cache-bust"]

  def keys, do: @override_keys

  def should_cache_bust?(envelope = %Envelope{}) do
    Map.has_key?(envelope.private.overrides, "belfrage-cache-bust")
  end
end
