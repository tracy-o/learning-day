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
    counter = ensure_counter_origin(counter, origin, key)
    {_, counter} = get_and_update_in(counter[origin][key], &{&1, &1 + 1})
    {_, counter} = get_and_update_in(counter[origin].errors, &{&1, &1 + 1})
    counter
  end

  def inc(_state, key) when key == :error do
    {:error, "key not allowed: ':error'"}
  end

  def inc(counter, key, origin) do
    counter = ensure_counter_origin(counter, origin, key)
    {_, counter} = get_and_update_in(counter[origin][key], &{&1, &1 + 1})
    counter
  end

  def exceed?(state, key, threshold) do
    get(state, key) > threshold
  end

  def get(state, key) do
    state[key] || 0
  end

  defp ensure_counter_origin(counter, origin, key) do
    counter
    |> ensure_origin(origin)
    |> ensure_key(origin, key)
  end

  defp ensure_key(counter, origin, key) do
    case Map.has_key?(counter[origin], key) do
      true  -> counter
      false -> put_in(counter, [origin, key], 0)
    end
  end

  defp ensure_origin(counter, origin) do
    case Map.has_key?(counter, origin) do
      true  -> counter
      false -> Map.put(counter, origin, %{errors: 0})
    end
  end
end
