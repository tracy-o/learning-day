defmodule Belfrage.Clients.HTTP.Headers do
  @doc ~S"""
  Output headers as a map, with the keys downcased.

  ## Examples
      iex> as_map([{"content-length", "0"}])
      %{"content-length" => "0"}

      iex> as_map([{"coNteNt-LenGth", "0"}])
      %{"content-length" => "0"}

      iex> as_map([{"coNteNt-tyPE", "apPlicaTion/JSON"}])
      %{"content-type" => "apPlicaTion/JSON"}
      
      iex> as_map(%{"coNteNt-tyPE" => "apPlicaTion/JSON"})
      %{"content-type" => "apPlicaTion/JSON"}
  """
  def as_map(headers) do
    headers
    |> downcase_headers()
    |> Enum.into(%{})
  end

  defp downcase_headers(headers) do
    Enum.map(headers, fn {k, v} -> {String.downcase(k), v} end)
  end
end