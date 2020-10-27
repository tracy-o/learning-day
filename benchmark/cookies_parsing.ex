defmodule Benchmark.CookiesParsing do
  @moduledoc """
  Performance benchmarking of `Plug.Conn.Cookies.decode/1`
  and custom codes `parse_cookies/1`

  ### To run this experiment
  ```
  	$ mix benchmark cookies_parsing # default cookie with 10 kv pairs, 1000 iterations (request)
    $ mix benchmark cookies_parsing 20 5000 # 20 kv-pair cookie, 5000 iterations of different cookies 
  ```
  """

  import Plug.Conn.Cookies, only: [decode: 1]

  def run([cookies_size]), do: experiment(cookies_size |> String.to_integer())

  def run([cookies_size, iterations]),
    do: experiment(cookies_size |> String.to_integer(), iterations |> String.to_integer())

  def run(_) do
    {:ok, _started} = Application.ensure_all_started(:belfrage)
    experiment()
  end

  def setup(cookies_size, iterations) do
    keys =
      for _ <- 1..cookies_size do
        string(8)
      end

    for _iteration <- 1..iterations do
      for key <- keys do
        to_string([key, ?=, string(30)])
      end
      |> Enum.join(";")
    end
  end

  def experiment(cookies_size \\ 10, iterations \\ 1000) do
    cookies = setup(cookies_size, iterations)

    Benchee.run(
      %{
        "parse_cookie/1" => fn -> Enum.each(cookies, &parse_cookie(&1)) end,
        "Plug.Conn.Cookies.decode/1" => fn -> Enum.each(cookies, &decode(&1)) end
      },
      time: 10,
      memory_time: 2
    )
  end

  defp string(size_in_bytes) do
    :crypto.strong_rand_bytes(size_in_bytes)
    |> Base.encode64()
    |> binary_part(0, size_in_bytes)
  end

  defp parse_cookie(""), do: %{}

  defp parse_cookie(cookie) do
    cookie
    |> String.split(";")
    |> Enum.map(&String.split(&1, "="))
    |> Map.new(&List.to_tuple/1)
  end
end
