defmodule Belfrage.CacheControl do
  @enforce_keys [:cacheability]
  defstruct @enforce_keys ++ [:max_age, :stale_if_error, :stale_while_revalidate]

  @behaviour Access

  @impl Access
  def fetch(struct, key), do: Map.fetch(struct, key)

  @impl Access
  def get_and_update(struct, key, fun) when is_function(fun, 1) do
    current = get(struct, key)

    case fun.(current) do
      {get, update} ->
        {get, put(struct, key, update)}

      :pop ->
        {current, delete(struct, key)}

      other ->
        raise "the given function must return a two-element tuple or :pop, got: #{inspect(other)}"
    end
  end

  @impl Access
  def pop(struct, key, default \\ nil) do
    val = get(struct, key, default)
    updated = delete(struct, key)
    {val, updated}
  end

  defp get(struct, key, default \\ nil) do
    case struct do
      %{^key => value} -> value
      _else -> default
    end
  end

  defp put(struct, key, val) do
    if Map.has_key?(struct, key) do
      Map.put(struct, key, val)
    else
      struct
    end
  end

  defp delete(struct, key) do
    put(struct, key, nil)
  end
end
