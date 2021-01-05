defmodule Belfrage.Dial do
  @callback transform(any()) :: any()
  @callback on_change(any()) :: :ok
  @optional_callbacks on_change: 1
end
