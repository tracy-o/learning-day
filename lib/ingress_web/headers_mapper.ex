defmodule IngressWeb.HeadersMapper do
  def map(req_headers) do
    Enum.into(map(), %{}, fn {k, v} ->
      {k, Enum.into(v, %{}, fn {i, j} -> {i, get_req_header(req_headers, j)} end)}
    end)
  end

  defp map do
    %{
      cache: %{edge: "x-bbc-edge-cache"},
      country: %{edge: "x-bbc-edge-country", varnish: "x-country"},
      host: %{edge: "x-bbc-edge-host", forwarded: "x-forwarded-host", http: "host"}
    }
  end

  defp get_req_header(headers, key) when headers == [{}] do
  end

  defp get_req_header(headers, key) do
    headers
    |> Enum.find({nil, nil}, fn {k, _v} -> k == key end)
    |> elem(1)
    |> empty_string_to_nil
  end

  defp empty_string_to_nil(v) when v == "" do
    nil
  end

  defp empty_string_to_nil(v) do
    v
  end
end
