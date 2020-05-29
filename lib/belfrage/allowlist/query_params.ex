defmodule Belfrage.Allowlist.QueryParams do
  alias Belfrage.Struct
  alias Struct.Private

  def filter(struct = %Struct{private: %Private{query_params_allowlist: "*"}}), do: struct

  def filter(struct = %Struct{request: request, private: %Private{query_params_allowlist: allowlist}}) do
    Struct.add(struct, :request, %{query_params: request.query_params |> Map.take(allowlist)})
  end
end
