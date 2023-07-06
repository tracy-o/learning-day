defmodule Belfrage.SmokeTestDiff do
  alias Test.Support.Helper

  @compare_bid System.get_env("WITH_DIFF")

  def build(response = %Finch.Response{headers: headers}, path, spec) do
    if "www" == Map.new(headers)["bid"] and @compare_bid do
      now_compare_with_live(response, path, spec)
    else
      :ok
    end
  end

  defp now_compare_with_live(_resp = %Finch.Response{headers: canary_headers}, path, spec) do
    live_endpoint = Application.get_env(:belfrage, :smoke)[:live][get_compare_endpoint()]
    {:ok, %Finch.Response{headers: live_headers}} = Helper.get_route(live_endpoint, path, [], spec)
    compare_headers(path, Map.new(canary_headers), Map.new(live_headers))
  end

  defp compare_headers(path, canary_headers, live_headers) do
    www_endpoint = "https://" <> Application.get_env(:belfrage, :smoke)[:live]["belfrage"] <> path
    named_endpoint = "https://" <> Application.get_env(:belfrage, :smoke)[:live][get_compare_endpoint()] <> path

    headers_mismatches =
      check_identical_headers(canary_headers, live_headers) ++ check_similar_headers(canary_headers, live_headers)

    case headers_mismatches do
      [] ->
        :ok

      reason ->
        to_log("\nPath: " <> path <> "\nRoutes: " <> www_endpoint <> ", " <> named_endpoint)
        for r <- reason, do: to_log(r)
        {:error, reason}
    end
  end

  defp check_identical_headers(canary_headers, live_headers) do
    ["cache-control", "content-type", "req-svc-chain", "vary"]
    |> Enum.reduce([], fn h, acc ->
      if canary_headers[h] != live_headers[h] do
        ["\"#{h}\" mismatch: www: #{canary_headers[h]} --- #{@compare_bid}: #{live_headers[h]}" | acc]
      else
        acc
      end
    end)
  end

  defp check_similar_headers(canary_headers, live_headers) do
    acceptance = 2.0

    perc_diff = fn h ->
      ch = String.to_integer(canary_headers[h])
      lh = String.to_integer(live_headers[h])

      dec = if ch + lh == 0, do: 0.0, else: abs(ch - lh) / ((ch + lh) / 2)
      Float.round(dec * 100, 2)
    end

    ["content-length"]
    |> Enum.reduce([], fn h, acc ->
      if perc_diff.(h) > acceptance do
        ["\"#{h}\" exceeding variance: www: #{canary_headers[h]} --- #{@compare_bid}: #{live_headers[h]}" | acc]
      else
        acc
      end
    end)
  end

  defp to_log(content) do
    {:ok, io_device} = File.open("resp_headers_diff.log", [:append])
    IO.puts(io_device, content)
    File.close(io_device)
  end

  defp get_compare_endpoint() do
    Application.get_env(:belfrage, :smoke)[:endpoint_to_stack_id_mapping]
    |> Enum.find(fn {_endpoint, id} -> id[:value] == @compare_bid end)
    |> elem(0)
  end
end
