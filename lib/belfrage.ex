defmodule Belfrage do
  alias Belfrage.{Processor, Struct, Cascade}
  alias BelfrageWeb.{StructAdapter, Response}
  alias Plug.Conn

  @callback handle(Struct.t()) :: Struct.t()

  def handle(struct = %Struct{}) do
    struct
    |> Cascade.build()
    |> Cascade.fan_out(fn struct ->
      struct
      |> Processor.pre_request_pipeline()
      |> Processor.fetch_early_response_from_cache()
    end)
    |> Cascade.result_or(&no_cached_response/1)
    |> Processor.post_response_pipeline()
  end

  def yield(id, conn) do
    conn = Conn.assign(conn, :route_spec, id)

    try do
      struct = StructAdapter.adapt(conn, id)

      conn
      |> Conn.assign(:struct, handle(struct))
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

  defp no_cached_response(cascade) do
    cascade
    |> Cascade.fan_out(&Processor.request_pipeline/1)
    |> Cascade.result_or(&Cascade.dispatch/1)
    |> Processor.response_pipeline()
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
