defmodule BelfrageWeb.RequestHeaders.Sanitiser do
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
    (headers[:edge] || headers[:forwarded] || headers[:http])
    |> to_string()
    |> String.replace(~r{\A\.}, "")
  end

  def scheme(headers, _cache) do
    headers[:edge]
    |> to_string()
    |> String.split(",", trim: true)
    |> Enum.find("https", fn x -> String.match?(x, ~r{^(http)(s)*$}) end)
    |> String.to_atom()
  end

  def replayed_traffic(%{replayed_traffic: "true"}, _), do: true
  def replayed_traffic(_, _), do: nil

  def playground(%{playground: "true"}, _), do: true
  def playground(_, _), do: nil

  def varnish(%{varnish: nil}, _), do: false
  def varnish(_, _), do: true

  defp edge(headers, true), do: headers[:edge]
  defp edge(_headers, false), do: nil
end
