defmodule FinchAPI do
  @callback request(Finch.Request.t(), atom(), keyword()) :: {:ok, Finch.Response.t()} | {:error, Exception.t()}

  def request(request, name, opts) do
    finch_impl().request(request, name, opts)
  end

  defp finch_impl() do
    Application.get_env(:belfrage, :finch_impl, Finch)
  end
end
