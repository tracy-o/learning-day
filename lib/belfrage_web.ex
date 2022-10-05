defmodule BelfrageWeb do
  alias BelfrageWeb.{StructAdapter, Response}
  alias Plug.Conn
  alias Belfrage.Metrics.LatencyMonitor

  @doc """
  Given an id corresponding to a route spec ID and a Conn:
    * Adapts the Conn to a Struct
    * Processes the Struct
    * puts a response.

  yield/3 also takes a platform_selector which
  is used to select a platform and complete the route spec ID.

  For example, yield/3 may take the args:

    yield("SomeRouteState", conn)

  which will not need the route spec ID to be completed.
  However the following call:

    yield("SomeRouteState", "SomePlatformSelector", conn)

  may result in the route state ID being completed internally to:

    "SomeRouteState.Webcore"

  or

    "SomeRouteState.MozartNews"

  as the Selector, here specified as "SomePlatformSelector", will
  select the Platform suffix.

  Likewise, a Platform can be specified as the second argument.
  The following yield/3 calls:

    yield("SomeRouteState", "Webcore", conn)
    yield("SomeRouteState", "MozartNews", conn)

  will result in the route state ID being completed internally to:

    "SomeRouteState.Webcore"
    "SomeRouteState.MozartNews"

  respectively.
  """
  def yield(id, conn) do
    conn = Conn.assign(conn, :route_spec, id)

    try do
      struct =
        StructAdapter.adapt(conn, id)
        |> LatencyMonitor.checkpoint(:request_received, conn.assigns[:request_received])

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

  def yield(id, platform_selector, conn) do
    try do
      struct =
        conn
        |> StructAdapter.Request.adapt()
        |> LatencyMonitor.checkpoint(:request_received, conn.assigns[:request_received])

      id = build_route_state_id(id, platform_selector, struct.request)

      struct = StructAdapter.Private.adapt(struct, conn.private, id)

      conn
      |> Conn.assign(:route_spec, id)
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

  # Uses the platform_selector and the request to
  # determine what platform suffix to add the route state id.
  # When the platform_selector is a Platform, the said
  # Platform is used as a suffix.
  #
  # Otherwise, the platform_selector is used to call
  # the corresponding Selector module, which
  # selects the correct Platform suffix.
  #
  # build_route_state_id/3 can take a list of incomplete route
  # state ids or a single incomplete route state id.
  # A route state id is "incomplete" if it does
  # not have a Platform suffix.
  defp build_route_state_id(ids, platform_selector, request) when is_list(ids) do
    Enum.map(ids, &build_route_state_id(&1, platform_selector, request))
  end

  defp build_route_state_id(route_state_id, platform_selector, request) do
    "#{route_state_id}.#{build_route_state_id(platform_selector, request)}"
  end

  # Here we iterate through a list of Platform strings, which
  # are used to create function clauses that return the Platform
  # string if the first argument to the function clause matches
  # the said Platform.
  for platform <- Routes.Platforms.list() do
    defp build_route_state_id(unquote(platform), _request), do: unquote(platform)
  end

  defp build_route_state_id(selector, request) do
    selector
    |> Routes.Platforms.Selector.call(request)
    |> Macro.to_string()
  end
end
