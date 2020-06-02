defmodule BelfrageWeb.RequestHeaders.Sanitiser do
  @moduledoc """
  """

  def cache(headers, _cache) do
    headers[:edge]
    |> to_string()
    |> String.equivalent?("1")
  end

  def cdn(%{http: "1"}, _cache), do: true
  def cdn(_headers, _cache), do: false

  def country(headers, cache) do
    edge(headers, cache) || headers[:varnish] || "gb"
  end

  def host(headers, _cache) do
    case headers[:edge] || headers[:forwarded] || headers[:http] do
      nil ->
        nil

      bbc_host ->
        bbc_host |> String.replace(~r{\A\.}, "")
    end
  end

  def is_uk(%{edge: "yes"}, true), do: true
  def is_uk(%{varnish: "yes"}, false), do: true
  def is_uk(_headers, _cache), do: false

  def language(%{varnish: language}, _cache), do: language
  def language_chinese(%{varnish: language}, _cache), do: language
  def language_serbian(%{varnish: language}, _cache), do: language

  def scheme(headers, _cache) do
    headers[:edge]
    |> to_string()
    |> String.split(",", trim: true)
    |> Enum.find("https", fn x -> String.match?(x, ~r{^(http)(s)*$}) end)
    |> String.to_atom()
  end

  def replayed_traffic(%{replayed_traffic: "true"}, _), do: true
  def replayed_traffic(_, _), do: nil

  def varnish(%{varnish: nil}, _), do: false
  def varnish(_, _), do: true

  def req_svc_chain(%{req_svc_chain: req_svc_chain}, _) do
    append_req_svc("BELFRAGE", req_svc_chain)
  end

  defp append_req_svc(belfrage_req_svc, _existing_req_svc = nil), do: belfrage_req_svc

  defp append_req_svc(belfrage_req_svc, existing_req_svc) do
    existing_req_svc <> "," <> belfrage_req_svc
  end

  defp edge(headers, true), do: headers[:edge]
  defp edge(_headers, false), do: nil
end
