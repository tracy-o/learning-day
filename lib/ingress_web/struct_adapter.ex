defmodule IngressWeb.StructAdapter do
  alias Ingress.Struct

  def adapt(loop_name, conn) do
    {loop_name,
     %Struct{
       request: %{},
       private: %{},
       response: %{}
     }}
  end
end
