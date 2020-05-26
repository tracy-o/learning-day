defmodule Belfrage.Headers do
  alias Belfrage.Struct
  alias Struct.Private

  def allowlist(struct = %Struct{private: %Private{headers_allowlist: "*"}}), do: struct

  def allowlist(struct = %Struct{request: request, private: %Private{headers_allowlist: allowlist}}) do
    Struct.add(struct, :request, %{raw_headers: request.raw_headers |> Map.take(allowlist)})
  end
end
