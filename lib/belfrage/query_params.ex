defmodule Belfrage.QueryParams do
  alias Belfrage.Struct
  alias Struct.Private

  def allowlist(struct = %Struct{private: %Private{query_params_allowlist: "*"}}), do: struct

  def allowlist(struct = %Struct{request: request, private: %Private{query_params_allowlist: allowlist}}) do
    Struct.add(struct, :request, %{query_params: request.query_params |> Map.take(allowlist)})
  end
end
