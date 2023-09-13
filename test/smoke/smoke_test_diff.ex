defmodule Belfrage.SmokeTestDiff do
  alias Test.Support.Helper

  @comparison_bid System.get_env("WITH_DIFF")

  def build(_resp = %Finch.Response{headers: resp_headers}, matcher_spec, "live") do
    if "www" == Map.new(resp_headers)["bid"] and @comparison_bid do
      now_compare_with_stack(resp_headers, matcher_spec.path, matcher_spec.headers, matcher_spec.spec)
    else
      :ok
    end
  end

  def build(_response, _matcher_spec, _env), do: :ok

  defp now_compare_with_stack(www_headers, path, req_headers, spec) do
    comparison_endpoint = get_live_endpoint(@comparison_bid)

    {:ok, %Finch.Response{headers: comparison_headers}} =
      Helper.get_route(comparison_endpoint, path, Map.to_list(req_headers))

    compare_headers(path, map_headers(www_headers, spec), map_headers(comparison_headers, spec))
  end

  defp compare_headers(path, www_headers, comparison_headers) do
    www_url = "https://" <> get_live_endpoint("www") <> path
    comparison_url = "https://" <> get_live_endpoint(@comparison_bid) <> path

    headers_mismatches =
      check_identical_headers(www_headers, comparison_headers) ++ check_similar_headers(www_headers, comparison_headers)

    case headers_mismatches do
      [] ->
        :ok

      reason ->
        to_log(
          "Path: " <> path <> "\n" <> www_url <> " || " <> comparison_url <> "\n" <> Enum.join(reason, "\n") <> "\n"
        )

        {:error, reason}
    end
  end

  defp check_identical_headers(www_headers, comparison_headers) do
    ["cache-control", "content-type", "req-svc-chain", "vary"]
    |> Enum.reduce([], fn h, acc ->
      if www_headers[h] != comparison_headers[h] do
        ["\"#{h}\" mismatch: www: #{www_headers[h]} --- #{@comparison_bid}: #{comparison_headers[h]}" | acc]
      else
        acc
      end
    end)
  end

  defp check_similar_headers(www_headers, comparison_headers) do
    acceptance = 5.0

    perc_diff = fn h ->
      wh = String.to_integer(www_headers[h])
      ch = String.to_integer(comparison_headers[h])

      dec = if wh + ch == 0, do: 0.0, else: abs(wh - ch) / ((wh + ch) / 2)
      Float.round(dec * 100, 2)
    end

    ["content-length"]
    |> Enum.reduce([], fn h, acc ->
      if perc_diff.(h) > acceptance do
        ["\"#{h}\" exceeding variance: www: #{www_headers[h]} --- #{@comparison_bid}: #{comparison_headers[h]}" | acc]
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

  defp get_live_endpoint(bid) do
    {endpoint_name, _} =
      Application.get_env(:belfrage, :smoke)[:endpoint_to_stack_id_mapping]
      |> Enum.find(fn {_e, id} -> id[:value] == bid end)

    Application.get_env(:belfrage, :smoke)[:live][endpoint_name]
  end

  defp map_headers(headers, spec) when is_list(headers), do: map_headers(Map.new(headers), spec)

  defp map_headers(headers = %{"req-svc-chain" => rsc}, "WorldService" <> _) do
    Map.put(headers, "req-svc-chain", String.replace(rsc, "FASTLY,GTM,", ""))
  end

  defp map_headers(headers, _spec), do: headers
end
