defmodule BelfrageWeb.Response.Headers.PipelineTrail do
  import Plug.Conn
  alias Belfrage.Envelope

  @behaviour BelfrageWeb.Response.Headers.Behaviour

  @impl true
  def add_header(conn, %Envelope{
        private: %Envelope.Private{production_environment: env},
        debug: %Envelope.Debug{
          pre_flight_pipeline_trail: pre_flight_trail,
          request_pipeline_trail: request_trail,
          response_pipeline_trail: response_trail
        }
      })
      when env != "live" do
    conn
    |> maybe_put_header("belfrage-pre-flight-pipeline-trail", pre_flight_trail)
    |> maybe_put_header("belfrage-request-pipeline-trail", request_trail)
    |> maybe_put_header("belfrage-response-pipeline-trail", response_trail)
  end

  @impl true
  def add_header(conn, _envelope) do
    conn
  end

  defp maybe_put_header(conn, _header, []), do: conn
  defp maybe_put_header(conn, header, trail), do: put_resp_header(conn, header, Enum.join(trail, ","))
end
