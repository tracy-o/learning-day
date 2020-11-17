defmodule Benchmark.VaryResponseHeaders do
  @moduledoc """
  Comparing new and previous implementations of
  `ResponseHeaders.Vary.add_header/2`.

  This benchmark measures the performance
  of both implementations when capability team adds custom vary
  headers in routespec (headers_allowlist) and Belfrage 
  adds the base + the additional headers to vary header.

  The test also involves "cookie" header that is removed and
  assesses the cost of doing so.

  ### To run this experiment
  ```
  	$ mix benchmark vary_response_headers # default 2 headers
    $ mix benchmark vary_response_headers 5 # 5 headers
  ```
  """

  import Plug.Conn, only: [put_resp_header: 3]
  import Plug.Test, only: [conn: 2]

  alias BelfrageWeb.ResponseHeaders.Vary
  alias Belfrage.Struct
  alias Belfrage.Struct.Private

  def run([header_size]), do: experiment(header_size |> String.to_integer())
  def run(_), do: experiment()

  def experiment(header_size \\ 2) do
    {:ok, _started} = Application.ensure_all_started(:belfrage)
    conn = conn(:get, "/")

    base_headers =
      for _ <- 1..header_size do
        string(8)
      end

    headers_with_cookie = base_headers ++ ["cookie"]

    Benchee.run(
      %{
        "prev: no headers" => fn ->
          add_header(conn, %Struct{private: %Private{headers_allowlist: []}})
        end,
        "prev: #{header_size} headers" => fn ->
          add_header(conn, %Struct{private: %Private{headers_allowlist: base_headers}})
        end,
        "prev: #{header_size + 1} headers with cookie" => fn ->
          add_header(conn, %Struct{private: %Private{headers_allowlist: headers_with_cookie}})
        end,
        "new: no headers" => fn ->
          Vary.add_header(conn, %Struct{private: %Private{headers_allowlist: []}})
        end,
        "new: #{header_size} headers" => fn ->
          Vary.add_header(conn, %Struct{private: %Private{headers_allowlist: base_headers}})
        end,
        "new: #{header_size + 1} headers with cookie" => fn ->
          Vary.add_header(conn, %Struct{private: %Private{headers_allowlist: headers_with_cookie}})
        end
      },
      time: 10,
      memory_time: 5
    )
  end

  defp string(size_in_bytes) do
    :crypto.strong_rand_bytes(size_in_bytes)
    |> Base.encode64()
    |> binary_part(0, size_in_bytes)
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
