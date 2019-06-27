defmodule IngressWeb.RequestHeaders.Sanitiser do
  @moduledoc """
  """

  def cache(headers, _cache) do
    headers[:edge]
    |> to_string()
    |> String.equivalent?("1")
  end

  def country(headers, cache) do
    edge(headers, cache) || headers[:varnish] || "gb"
  end

  def host(headers, _cache) do
    headers[:edge] || headers[:forwarded] || headers[:http]
  end

  def replayed_traffic(%{replayed_traffic: "true"}, _), do: true
  def replayed_traffic(_, _), do: nil

  defp edge(headers, true) do
    headers[:edge]
  end

  defp edge(headers, false) do
    nil
  end
end
