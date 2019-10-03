defmodule Belfrage.Clients.HTTP.Request do
  defstruct [
    :method,
    :url,
    payload: "",
    headers: [],
    timeout: Application.get_env(:belfrage, :default_timeout)
  ]

  @type t :: %__MODULE__{
    method: :get | :post,
    url: String.t(),
    payload: String.t() | map(),
    headers: list(),
    timeout: integer()
  }

  @doc ~S"""
  Adds headers to the request struct, after downcasing them

  ## Examples
      iex> downcase_headers(%Belfrage.Clients.HTTP.Request{headers: [{"content-length", "0"}]})
      %Belfrage.Clients.HTTP.Request{headers: [{"content-length", "0"}]}

      iex> downcase_headers(%Belfrage.Clients.HTTP.Request{headers: [{"coNteNt-LenGth", "0"}]})
      %Belfrage.Clients.HTTP.Request{headers: [{"content-length", "0"}]}

      iex> downcase_headers(%Belfrage.Clients.HTTP.Request{headers: [{"coNteNt-tyPE", "apPlicaTion/JSON"}]})
      %Belfrage.Clients.HTTP.Request{headers: [{"content-type", "apPlicaTion/JSON"}]}
  """
  def downcase_headers(request = %__MODULE__{}) do
    Map.put(request, :headers, downcase(request.headers))
  end

  defp downcase(headers) do
    Enum.map(headers, fn {k, v} -> {String.downcase(k), v} end)
  end
end
