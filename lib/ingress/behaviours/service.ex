defmodule Ingress.Behaviours.Service do
  @callback dispatch(map()) :: map()
end
