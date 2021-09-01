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

  def is_advertise(%{edge: "yes"}, true), do: true
  def is_advertise(%{varnish: "yes"}, false), do: true
  def is_advertise(_headers, _cache), do: false

  def scheme(headers, _cache) do
    headers[:edge]
    |> to_string()
    |> String.split(",", trim: true)
    |> Enum.find("https", fn x -> String.match?(x, ~r{^(http)(s)*$}) end)
    |> String.to_atom()
  end

  def replayed_traffic(%{replayed_traffic: "true"}, _), do: true
  def replayed_traffic(_, _), do: nil

  def origin_simulator(%{origin_simulator: "true"}, _), do: true
  def origin_simulator(_, _), do: nil

  def req_svc_chain(%{req_svc_chain: req_svc_chain}, _) do
    append_req_svc("BELFRAGE", req_svc_chain)
  end

  defp append_req_svc(belfrage_req_svc, _existing_req_svc = nil), do: belfrage_req_svc

  defp append_req_svc(belfrage_req_svc, existing_req_svc) do
    existing_req_svc <> "," <> belfrage_req_svc
  end

  defp edge(headers, true), do: headers[:edge]
  defp edge(_headers, false), do: nil

  def x_candy_audience(headers, _cache), do: headers[:x_candy_audience]
  def x_candy_override(headers, _cache), do: headers[:x_candy_override]
  def x_candy_preview_guid(headers, _cache), do: headers[:x_candy_preview_guid]
  def x_morph_env(headers, _cache), do: headers[:x_morph_env]
  def x_use_fixture(headers, _cache), do: headers[:x_use_fixture]
  def cookie_ckps_language(headers, _cache), do: headers[:cookie_ckps_language]
  def cookie_ckps_chinese(headers, _cache), do: headers[:cookie_ckps_chinese]
  def cookie_ckps_serbian(headers, _cache), do: headers[:cookie_ckps_serbian]
  def origin(headers, _cache), do: headers[:origin]
  def referer(headers, _cache), do: headers[:referer]
  def user_agent(headers, _cache), do: headers[:user_agent]
end
