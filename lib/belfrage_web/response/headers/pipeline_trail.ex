defmodule BelfrageWeb.Response.Headers.PipelineTrail do
  import Plug.Conn
  alias Belfrage.Struct

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn, %Struct{
        private: %Struct.Private{production_environment: env},
        debug: %Struct.Debug{pipeline_trail: trail}
      })
      when env != "live" and is_list(trail) and trail != [] do
    put_resp_header(conn, "belfrage-pipeline-trail", Enum.join(trail, ","))
  end

  @impl true
  def add_header(conn, _struct) do
    conn
  end
end
