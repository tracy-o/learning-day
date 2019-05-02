defmodule Ingress.Services.HTTPMock do
  alias Ingress.{Struct, Behaviours}
  @behaviour Behaviours.Service

  @impl Behaviours.Service
  def dispatch(struct = %Struct{}), do: struct
end
