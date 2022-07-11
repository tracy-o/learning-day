defmodule BelfrageWeb do
  alias BelfrageWeb.{StructAdapter, Response}
  alias Belfrage
  alias Plug.Conn

  def yield(id, conn) do
    conn = Conn.assign(conn, :route_spec, id)

    try do
      struct = StructAdapter.adapt(conn, id)

      conn
      |> Conn.assign(:struct, Belfrage.handle(struct))
      |> Response.put()
    catch
      # Unwrap an internal Belfrage error to extract %Struct{} from it
      _, error = %Belfrage.WrapperError{} ->
        conn = Conn.assign(conn, :struct, error.struct)
        reraise(conn, error.kind, error.reason, error.stack)

      kind, reason ->
        reraise(conn, kind, reason, __STACKTRACE__)
    end
  end

  defp reraise(conn, kind, reason, stack) do
    # Wrap the error in `Plug.Conn.WrapperError` to preserve the `conn`
    # which now contains the name of the route spec and the struct, so that
    # we could use that data when generating an error response or tracking
    # metrics.
    wrapper = %Conn.WrapperError{conn: conn, kind: kind, reason: reason, stack: stack}
    :erlang.raise(kind, wrapper, stack)
  end
end
