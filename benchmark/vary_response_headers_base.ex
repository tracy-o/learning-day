defmodule Benchmark.VaryResponseHeadersBase do
  @moduledoc """
  Comparing new and previous implementations of
  `ResponseHeaders.Vary.add_header/2`.

  This benchmark measures the performance
  of both implementations when headers_allowlist = [] and Belfrage
  adds the base vary header (in most request cases).

  ### To run this experiment
  ```
  	$ mix benchmark vary_response_headers_base
  ```
  """

  import Plug.Conn, only: [put_resp_header: 3]
  import Plug.Test, only: [conn: 2]

  alias BelfrageWeb.Response.Headers.Vary
  alias Belfrage.Struct
  alias Belfrage.Struct.Private

  def run(_), do: experiment()

  def experiment() do
    {:ok, _started} = Application.ensure_all_started(:belfrage)
    conn = conn(:get, "/")

    Benchee.run(
      %{
        "prev: add base header" => fn -> add_header(conn, %Struct{private: %Private{headers_allowlist: []}}) end,
        "new: add base header" => fn -> Vary.add_header(conn, %Struct{private: %Private{headers_allowlist: []}}) end
      },
      time: 10,
      memory_time: 5
    )
  end

  ## previous implementation
  def add_header(conn, %Struct{request: request, private: private}) do
    put_resp_header(
      conn,
      "vary",
      vary_headers(request, private, request.cdn?)
    )
  end

  def vary_headers(request, private, false) do
    [
      "Accept-Encoding",
      "X-BBC-Edge-Cache",
      country(edge_cache: request.edge_cache?),
      is_uk(request.edge_cache?),
      "X-BBC-Edge-Scheme",
      additional_headers(private.headers_allowlist)
    ]
    |> Enum.reject(&is_nil/1)
    |> Enum.join(",")
  end

  def vary_headers(_request, _private, true) do
    "Accept-Encoding"
  end

  def country(edge_cache: true), do: "X-BBC-Edge-Country"
  def country(edge_cache: false), do: "X-Country"

  def is_uk(true), do: "X-BBC-Edge-IsUK"
  def is_uk(false), do: "X-IP_Is_UK_Combined"

  defp additional_headers(allowed_headers) when allowed_headers == [], do: nil

  defp additional_headers(allowed_headers) do
    allowed_headers
    |> Enum.join(",")
  end
end
