defmodule Belfrage.CacheControl.FindValue do
  def find(["stale-if-error=" <> value | _rest], key: :stale_if_error, default: _) do
    {num, _string} = Integer.parse(value)
    num
  end

  def find(["stale-while-revalidate=" <> value | _rest], key: :stale_while_revalidate, default: _) do
    {num, _string} = Integer.parse(value)
    num
  end

  def find(["max-age=" <> value | _rest], key: :max_age, default: _) do
    {num, _string} = Integer.parse(value)
    num
  end

  def find(header_values, opts) when length(header_values) > 0 do
    header_values
    |> List.delete_at(0)
    |> find(opts)
  end

  def find(_, key: _, default: default), do: default
end
