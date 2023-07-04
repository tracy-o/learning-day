defmodule Belfrage.SmokeTestDiff do
  alias Test.Support.Helper

  @compare_to System.get_env("WITH_DIFF")

  def build(response = %Finch.Response{headers: headers}, path, spec) do
    if "www" == Map.new(headers)["bid"] and @compare_to do
      now_compare_with_live(response, path, spec)
    else
      :ok
    end
  end

  defp to_log(content) do
    {:ok, io_device} = File.open("output.log", [:append])
    IO.puts(io_device, content)
    File.close(io_device)
  end

  defp now_compare_with_live(_resp = %Finch.Response{headers: canary_headers}, path, spec) do
    {endpoint_name, _} =
      Application.get_env(:belfrage, :smoke)[:endpoint_to_stack_id_mapping]
      |> Enum.find(fn {_endpoint, id_map} -> id_map[:value] == @compare_to end)

    live_endpoint = Application.get_env(:belfrage, :smoke)[:live][endpoint_name]
    {:ok, %Finch.Response{headers: live_headers}} = Helper.get_route(live_endpoint, path, [], spec)

    compare_headers(path, Map.new(canary_headers), Map.new(live_headers))
  end

  defp compare_headers(path, canary_headers, live_headers) do
    headers_mismatches =
      check_identical_headers(canary_headers, live_headers) ++ check_similar_headers(canary_headers, live_headers)

    case headers_mismatches do
      [] ->
        :ok

      reason ->
        to_log(reason <> " || " <> path)
        {:error, reason}
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
      c = String.to_integer(canary_headers[h])
      l = String.to_integer(live_headers[h])

      diff = abs(c - l) / ((c + l) / 2)
      Float.round(diff * 100, 2)
    end

    ["content-length"]
    |> Enum.reduce([], fn h, acc ->
      if perc_diff.(h) > acceptance do
        acc ++
          "Response header #{h} exceeding variance: www: #{canary_headers[h]}, #{@compare_to}: #{live_headers[h]}\n > Diff: #{perc_diff.(h)}%"
      else
        acc
      end
    end)
  end
end
