defmodule Json do
  def encode!(val), do: :jiffy.encode(val)

  def decode!(val), do: :jiffy.decode(val, [:return_maps])
end
