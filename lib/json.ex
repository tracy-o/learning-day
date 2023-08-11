defmodule Json do
  @spec encode!(map()) :: iodata()
  def encode!(val), do: IO.iodata_to_binary(:jiffy.encode(val))

  @spec decode!(iodata()) :: map()
  def decode!(val), do: :jiffy.decode(val, [:return_maps])

  @spec decode(iodata()) :: {:ok, map()} | {:error, any()}
  def decode(val) do
    try do
     {:ok, decode!(val)}
    catch
      :error, reason -> {:error, reason}
    end
  end
end
