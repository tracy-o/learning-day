defmodule FinchAPI do
  @callback request(Finch.Request.t(), atom(), keyword()) :: {:ok, Finch.Response.t()} | {:error, Exception.t()}
end
