defmodule Belfrage.Behaviours.ResponseTransformer do
  alias Belfrage.Struct
  @callback call(Struct.t()) :: Struct.t()
end
