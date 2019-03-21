defmodule IngressMock do
  @behaviour Ingress
  alias Ingress.{Struct}

  @impl Ingress
  def handle({_loop_name, struct = Struct}), do: struct
end
