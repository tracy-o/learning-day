defmodule Ingress.Counter do
  defmacro is_error(http_status) do
    quote do
      unquote(http_status) in 500..504 or unquote(http_status) == 408
    end
  end

  def init do
    %{}
  end

  def inc(counter, key, origin) when is_error(key) do
    counter
    |> increment_key(origin, key)
    |> increment_key(origin, :errors)
    |> Map.update(:errors, 1, &(&1 + 1))
  end

  def inc(_state, key, _origin) when key == :error do
    {:error, "key not allowed: ':error'"}
  end

  def inc(counter, key, origin) do
    counter
    |> increment_key(origin, key)
  end

  def exceed?(state, key, threshold) do
    get(state, key) > threshold
  end

  def get(state, key) do
    state[key] || 0
  end

  defp increment_key(counter, origin, key) do
    ensure_origin(counter, origin)
    {_, counter} = get_and_update_in([origin, key], &{&1, (&1 || 0) + 1})
    counter
  end

  defp ensure_origin(counter, origin) do
    case Map.has_key?(counter, origin) do
      true -> counter
      false -> Map.put(counter, origin, %{errors: 0})
    end
  end
end
