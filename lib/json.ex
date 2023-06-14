defmodule Json do
  def encode!(val), do: IO.iodata_to_binary(:jiffy.encode(val))

  def decode!(val), do: :jiffy.decode(val, [:return_maps])

  def decode(val), do: :jiffy.decode(val, [:return_maps])
end
