defmodule BelfrageWeb.Response.Headers.PipelineTrail do
  import Plug.Conn
  alias Belfrage.Envelope

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn, %Envelope{
        private: %Envelope.Private{production_environment: env},
        debug: %Envelope.Debug{request_pipeline_trail: request_trail, response_pipeline_trail: response_trail}
      })
      when env != "live" and is_list(response_trail) and response_trail != [] do
    conn
    |> put_resp_header("belfrage-request-pipeline-trail", Enum.join(request_trail, ","))
    |> put_resp_header("belfrage-response-pipeline-trail", Enum.join(response_trail, ","))
  end

  @impl true
  def add_header(conn, %Envelope{
        private: %Envelope.Private{production_environment: env},
        debug: %Envelope.Debug{request_pipeline_trail: trail}
      })
      when env != "live" and is_list(trail) and trail != [] do
    put_resp_header(conn, "belfrage-request-pipeline-trail", Enum.join(trail, ","))
  end

  @impl true
  def add_header(conn, _envelope) do
    conn
  end
end
