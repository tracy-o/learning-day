defmodule BelfrageWeb.RequestHeaders.Mapper do
  @map %{
    cache: %{edge: "x-bbc-edge-cache"},
    country: %{edge: "x-bbc-edge-country", varnish: "x-country"},
    host: %{edge: "x-bbc-edge-host", forwarded: "x-forwarded-host", http: "host"},
    scheme: %{edge: "x-bbc-edge-scheme"},
    replayed_traffic: %{replayed_traffic: "replayed-traffic"},
    playground: %{playground: "playground"},
    varnish: %{varnish: "x-varnish"}
  }

  def map(req_headers) do
    Enum.into(@map, %{}, fn {header_key, headers_map} ->
      {header_key,
       Enum.into(headers_map, %{}, fn {bbc_header_from, bbc_header_key} ->
         {bbc_header_from, get_req_header(req_headers, bbc_header_key)}
       end)}
    end)
  end

  defp get_req_header(headers, _key) when headers == [{}], do: nil

  defp get_req_header(headers, key) do
    headers
    |> Enum.find({nil, nil}, fn {k, _v} -> k == key end)
    |> elem(1)
    |> empty_string_to_nil
  end

  defp empty_string_to_nil(v) when v == "", do: nil

  defp empty_string_to_nil(v), do: v
end
