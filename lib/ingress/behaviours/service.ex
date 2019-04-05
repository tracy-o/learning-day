defmodule Ingress.Behaviours.Service do
  alias Ingress.Struct
  @callback dispatch(Struct.t()) :: Struct.t()
end
