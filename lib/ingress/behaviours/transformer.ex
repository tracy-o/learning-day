defmodule Ingress.Behaviours.Transformer do
  @callback call([String.t], struct()) :: {:ok, struct()} | {:error, struct, String.t}
end
