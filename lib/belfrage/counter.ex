defmodule Belfrage.Counter do
  @error_statuses [500, 501, 502, 503, 504, 408]

  def init do
    %{}
  end

  def inc(counter, status, origin, opts \\ []) do
    fallback = Keyword.get(opts, :fallback, false)

    cond do
      not is_number(status) ->
        {:error, "'status' must be an integer"}

      fallback ->
        increment_key(counter, :fallback, origin)

      status in @error_statuses ->
        increment_error(counter, status, origin)

      true ->
        increment_key(counter, status, origin)
    end
  end

  defp increment_error(counter, status, origin) do
    counter
    |> increment_key(status, origin)
    |> increment_key(:errors, origin)
    |> Map.update(:errors, 1, &(&1 + 1))
  end

  def exceed?(state, key, threshold) do
    get(state, key) > threshold
  end

  def get(state, key) do
    state[key] || 0
  end

  defp increment_key(counter, key, origin) do
    counter
    |> ensure_origin(origin)
    |> get_and_update_in([origin, key], &{&1, (&1 || 0) + 1})
    |> elem(1)
  end

  defp ensure_origin(counter, origin) do
    case Map.has_key?(counter, origin) do
      true -> counter
      false -> Map.put(counter, origin, %{errors: 0})
    end
  end
end
