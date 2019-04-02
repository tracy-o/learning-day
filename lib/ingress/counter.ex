defmodule Ingress.Counter do
  defmacro is_error(http_status) do
    quote do
      unquote(http_status) in 500..504 or unquote(http_status) == 408
    end
  end

  def init do
    %{}
  end

  def inc(state, key) when is_error(key) do
    state
    |> Map.update(:errors, 1, &(&1 + 1))
    |> Map.update(key, 1, &(&1 + 1))
  end

  def inc(_state, key) when key == :error do
    {:error, "key not allowed: ':error'"}
  end

  def inc(state, key) do
    Map.update(state, key, 1, &(&1 + 1))
  end

  def exceed?(state, key, threshold) do
    get(state, key) > threshold
  end

  def get(state, key) do
    state[key] || 0
  end
end
