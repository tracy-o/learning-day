defmodule BelfrageWeb do
  alias BelfrageWeb.{EnvelopeAdapter, Response}
  alias Plug.Conn
  alias Belfrage.{Metrics.LatencyMonitor, Envelope, RouteSpec}
  alias Belfrage.Behaviours.Selector

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
  def yield(spec_or_selector, platform_or_selector, conn) do
    try do
      envelope =
        conn
        |> EnvelopeAdapter.Request.adapt()
        |> LatencyMonitor.checkpoint(:request_received, conn.assigns[:request_received])

      case build_route_state_id(spec_or_selector, platform_or_selector, envelope.request) do
        {:ok, route_state_id} ->
          envelope = EnvelopeAdapter.Private.adapt(envelope, conn.private, route_state_id)

          conn
          |> Conn.assign(:route_spec, route_state_id)
          |> Conn.assign(:envelope, Belfrage.handle(envelope))
          |> Response.put()

        {:error, selector, status_code} ->
          :telemetry.execute([:belfrage, :selector, :error], %{}, %{selector: selector})
          Logger.log(:error, "", %{msg: "Selector '#{selector}' failed", reason: status_code})

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

  defp build_route_state_id(spec_or_selector, platform_or_selector, request) do
    case get_name(platform_or_selector, :platform, request) do
      {:ok, platform_name} ->
        case get_name(spec_or_selector, :spec, request) do
          {:ok, spec_name_partition} ->
            {:ok, make_route_state_id(spec_name_partition, platform_name)}

          {:error, reason} ->
            {:error, spec_or_selector, reason}
        end

      {:error, reason} ->
        {:error, platform_or_selector, reason}
    end
  end

  defp get_name(name, type, request) do
    if Selector.selector?(name) do
      Selector.call(name, type, request)
    else
      {:ok, name}
    end
  end

  defp make_route_state_id({spec_name, partition}, platform_name) do
    RouteSpec.make_route_state_id(spec_name, platform_name, partition)
  end

  defp make_route_state_id(spec_name, platform_name) when is_binary(spec_name) do
    RouteSpec.make_route_state_id(spec_name, platform_name)
  end
end
