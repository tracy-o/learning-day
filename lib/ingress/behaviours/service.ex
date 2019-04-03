defmodule Ingress.Behaviours.Service do
  alias Ingress.Struct
  @callback dispatch(Struct) :: Struct
end
