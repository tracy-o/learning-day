defmodule Ingress.Behaviours.Transformer do
  alias Ingress.Struct
  @callback call([String.t()], Struct.t()) :: {:ok, Struct.t()} | {:error, Struct.t(), String.t()}
end
