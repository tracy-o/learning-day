defmodule IngressMock do
  @behaviour Ingress
  alias Ingress.{Struct}

  @impl Ingress
  def handle(struct = Struct), do: struct
end
