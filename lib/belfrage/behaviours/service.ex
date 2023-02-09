defmodule Belfrage.Behaviours.Service do
  alias Belfrage.Envelope
  @callback dispatch(Envelope.t()) :: Envelope.t()
end
