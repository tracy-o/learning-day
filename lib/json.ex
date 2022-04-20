defmodule Json do
  @compile {:inline, encode!: 1}
  def encode!(val), do: :jiffy.encode(val)

  @compile {:inline, decode!: 1}
  def decode!(val), do: :jiffy.decode(val, [:return_maps])
end
