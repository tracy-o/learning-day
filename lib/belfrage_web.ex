defmodule BelfrageWeb do
  alias BelfrageWeb.{StructAdapter, Response}
  alias Plug.Conn
  alias Belfrage.{Metrics.LatencyMonitor, Struct}

  @doc """
  Given an id corresponding to a route spec ID and a Conn:
    * Adapts the Conn to a Struct
    * Processes the Struct
    * puts a response.

  yield/3 takes a platform_selector which
  is used to select a platform and complete the route spec ID.

  The following call:

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
  def yield(id, platform_selector, conn) do
    try do
      struct =
        conn
        |> StructAdapter.Request.adapt()
        |> LatencyMonitor.checkpoint(:request_received, conn.assigns[:request_received])

      case build_route_state_id(id, platform_selector, struct.request) do
        {:ok, route_state_id} ->
          struct = StructAdapter.Private.adapt(struct, conn.private, route_state_id)

          conn
          |> Conn.assign(:route_spec, id)
          |> Conn.assign(:struct, Belfrage.handle(struct))
          |> Response.put()

        {:error, status_code} ->
          conn
          |> Conn.assign(:struct, Struct.put_status(%Struct{}, status_code))
          |> Response.put()
      end
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
    {:ok, Enum.map(ids, &build_route_state_id(&1, platform_selector, request))}
  end

  defp build_route_state_id(route_state_id, platform_selector, request) do
    with {:ok, platform} <- Routes.Platforms.Selector.call(platform_selector, request) do
      {:ok, "#{route_state_id}.#{platform}"}
    end
  end
end
