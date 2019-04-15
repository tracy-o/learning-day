defmodule IngressWeb.HeadersSanitiser do
  @moduledoc """
  """

  alias IngressWeb.HeadersMapper

  def cache(headers, _cache) do
    headers[:edge]
    |> to_string()
    |> String.equivalent?("1")
  end

  def country(headers, cache) do
    edge(headers, cache) || headers[:varnish] ||
      "gb"
      |> to_string()
  end

  def host(headers, _cache) do
    headers[:edge] || headers[:forwarded] || headers[:http]
  end

  defp edge(headers, true) do
    headers[:edge]
  end

  defp edge(headers, false) do
    nil
  end
end
