defmodule Belfrage.AWS do
  @type options :: [security_token: String.t(), access_key_id: String.t(), secret_access_key: String.t()]
  @callback request(ExAws.Operation.Query.t(), options) :: {:ok, %{body: map()}} | {:error, any()} | {:error, {:http_error, Integer.t(), any()}}
  @callback request(ExAws.Operation.Query.t()) :: {:ok, %{body: map()}} | {:error, any()} | {:error, {:http_error, Integer.t(), any()}}

  defdelegate request(operation, options \\ []), to: ExAws
end
