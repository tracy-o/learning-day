defmodule Belfrage.AWS do
  @callback request(ExAws.Operation.Query.t()) :: {:ok, %{body: map()}} | {:error, any()} | {:error, {:http_error, Integer.t(), any()}}

  defdelegate request(operation), to: ExAws
end
