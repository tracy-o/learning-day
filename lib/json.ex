defmodule Json do
  def encode!(val), do: :jiffy.encode(val)

  def decode!(val), do: :jiffy.decode(val, [:return_maps])

  def decode(val) do
    {:ok, decode!(val)}
  rescue
    e -> {:error, e}
  end

  def encode(val) do
    {:ok, encode!(val)}
  rescue
    e -> {:error, e}
  end
end
