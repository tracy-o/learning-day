defmodule Belfrage.Behaviours.Transformer do
  alias Belfrage.Struct
  @callback call([String.t()], Struct.t()) :: {:ok, Struct.t()} | {:error, Struct.t(), String.t()}
end
