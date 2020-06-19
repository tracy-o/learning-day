defmodule Belfrage.Behaviours.Service do
  alias Belfrage.Struct
  @callback dispatch(Struct.t() | [Struct.t()]) :: Struct.t()
end
