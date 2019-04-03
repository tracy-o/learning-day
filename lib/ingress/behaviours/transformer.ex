defmodule Ingress.Behaviours.Transformer do
  alias Ingress.Struct
  @callback call([String.t()], Struct) :: {:ok, Struct} | {:error, Struct, String.t()}
end
