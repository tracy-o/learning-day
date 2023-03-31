defmodule BelfrageWeb do
  alias BelfrageWeb.{EnvelopeAdapter, Response}
  alias Plug.Conn
  alias Belfrage.{Metrics.LatencyMonitor, Envelope}

  require Logger

  def yield(spec, _platform, conn) do
    try do
      conn
      |> adapt_envelope(spec)
      |> Belfrage.handle()
      |> update_conn_with_response(conn)
    catch
      _, error = %Belfrage.WrapperError{} ->
        conn = Conn.assign(conn, :envelope, error.envelope)
        reraise(conn, error.kind, error.reason, error.stack)

      kind, reason ->
        reraise(conn, kind, reason, __STACKTRACE__)
    end
  end

  defp adapt_envelope(conn, spec) do
    conn
    |> EnvelopeAdapter.Request.adapt()
    |> EnvelopeAdapter.Private.adapt(conn.private, spec)
    |> LatencyMonitor.checkpoint(:request_received, conn.assigns[:request_received])
  end

  defp update_conn_with_response(resp_envelope = %Envelope{private: private}, conn) do
    conn
    |> Conn.assign(:route_spec, private.route_state_id)
    |> Conn.assign(:envelope, resp_envelope)
    |> Response.put()
  end

  defp reraise(conn, kind, reason, stack) do
    # Wrap the error in `Plug.Conn.WrapperError` to preserve the `conn`
    # which now contains the name of the route spec and the envelope, so that
    # we could use that data when generating an error response or tracking
    # metrics.
    wrapper = %Conn.WrapperError{conn: conn, kind: kind, reason: reason, stack: stack}
    :erlang.raise(kind, wrapper, stack)
  end
end
