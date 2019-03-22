defmodule IngressWeb.StructAdapter do
  alias Ingress.Struct
  alias Ingress.Struct.{Request}

  def adapt(loop_name, conn) do
    {loop_name,
     %Struct{
       request: %Request{
         path: conn.request_path,
         payload: conn.body_params
       }
     }}
  end
end
