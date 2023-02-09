defmodule BelfrageWeb do
  alias BelfrageWeb.{EnvelopeAdapter, Response}
  alias Plug.Conn
  alias Belfrage.{Metrics.LatencyMonitor, Envelope, RouteSpec, RouteSpecManager}

  require Logger

  @doc """
  Given an id corresponding to a route spec ID and a Conn:
    * Adapts the Conn to a Envelope
    * Processes the Envelope
    * puts a response.

  yield/3 takes a platform_or_selector which
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
  def yield(id, platform_or_selector, conn) do
    try do
      envelope =
        conn
        |> EnvelopeAdapter.Request.adapt()
        |> LatencyMonitor.checkpoint(:request_received, conn.assigns[:request_received])

      case build_route_state_id(id, platform_or_selector, envelope.request) do
        {:ok, route_state_id} ->
          envelope = EnvelopeAdapter.Private.adapt(envelope, conn.private, route_state_id)

          conn
          |> Conn.assign(:route_spec, route_state_id)
          |> Conn.assign(:envelope, Belfrage.handle(envelope))
          |> Response.put()

        {:error, status_code} ->
          :telemetry.execute([:belfrage, :platform_selector, :not_found], %{}, %{selector: platform_or_selector})
          Logger.log(:error, "", %{msg: "Selector '#{platform_or_selector}' not found", reason: status_code})

          conn
          |> Conn.assign(:envelope, Envelope.put_status(%Envelope{}, status_code))
          |> Response.put()
      end
    catch
      # Unwrap an internal Belfrage error to extract %Envelope{} from it
      _, error = %Belfrage.WrapperError{} ->
        conn = Conn.assign(conn, :envelope, error.envelope)
        reraise(conn, error.kind, error.reason, error.stack)

      kind, reason ->
        reraise(conn, kind, reason, __STACKTRACE__)
    end
  end

  defp reraise(conn, kind, reason, stack) do
    # Wrap the error in `Plug.Conn.WrapperError` to preserve the `conn`
    # which now contains the name of the route spec and the envelope, so that
    # we could use that data when generating an error response or tracking
    # metrics.
    wrapper = %Conn.WrapperError{conn: conn, kind: kind, reason: reason, stack: stack}
    :erlang.raise(kind, wrapper, stack)
  end

  defp build_route_state_id(spec_name, platform_or_selector, request) do
    route_state_id = RouteSpec.make_route_state_id(spec_name, platform_or_selector)

    case RouteSpecManager.get_spec(route_state_id) do
      nil -> call_platform_selector(spec_name, platform_or_selector, request)
      %RouteSpec{} -> {:ok, route_state_id}
    end
  end

  defp call_platform_selector(spec_name, selector, request) do
    with {:ok, platform} <- Routes.Platforms.Selector.call(selector, request) do
      {:ok, RouteSpec.make_route_state_id(spec_name, platform)}
    end
  end
end
