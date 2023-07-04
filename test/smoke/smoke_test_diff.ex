defmodule Belfrage.SmokeTestDiff do
  @compare_to System.get_env("WITH_DIFF")

  def build(response, path, spec) do
    if @compare_to, do: now_compare_with_live(response, path, spec) |> IO.inspect(label: "comparing")
  end

  defp now_compare_with_live(_resp = %Finch.Response{headers: canary_headers}, path, spec) do
    live_endpoint = Application.get_env(:belfrage, :smoke)[:live][endpoint_name()]

    {:ok, %Finch.Response{headers: live_headers}} = Helper.get_route(live_endpoint, path, spec)

    compare_headers(Map.new(canary_headers), Map.new(live_headers))
  end

  defp endpoint_name() do
    Application.get_env(:belfrage, :smoke)[:endpoint_to_stack_id_mapping]
      |> Enum.find(fn {_endpoint, id_map} -> id_map[:value] == @compare_to end)
      |> elem(0)
  end

  defp compare_headers(canary_headers, live_headers) do
    headers_mismatches =
      check_identical_headers(canary_headers, live_headers) ++ check_similar_headers(canary_headers, live_headers)

    case headers_mismatches do
      [] -> :ok
      reason -> {:error, reason}
    end
  end

  defp check_identical_headers(canary_headers, live_headers) do
    ["cache-control", "content-type", "req-svc-chain", "vary"]
    |> Enum.reduce([], fn h, acc ->
      if canary_headers[h] != live_headers[h] do
        acc ++ "Response header #{h} mismatch: canary: #{canary_headers[h]}, live: #{live_headers[h]}"
      else
        acc
      end
    end)
  end

  defp check_similar_headers(canary_headers, live_headers) do
    acceptance = 1.0

    perc_diff = fn h ->
      ch = String.to_integer(canary_headers[h])
      lh = String.to_integer(live_headers[h])

      ((ch - lh) / lh * 100)
      |> abs()
    end

    ["content-length"]
    |> Enum.reduce([], fn h, acc ->
      if perc_diff.(h) > acceptance do
        acc ++ "Response header #{h} exceeding variance: canary: #{canary_headers[h]}, live: #{live_headers[h]}"
      else
        acc
      end
    end)
  end
end
