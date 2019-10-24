defmodule Belfrage.QueryParams do
  alias Belfrage.Struct
  alias Struct.Private

  def allowlist(struct = %Struct{private: %Private{query_params_allowlist: "*"}}) do
    struct
  end

  def allowlist(struct = %Struct{private: %Private{query_params_allowlist: allowlist}}) do
    query_params = struct.request.query_params |> Map.take(allowlist)

    Struct.add(struct, :request, %{query_params: query_params})
  end
end
