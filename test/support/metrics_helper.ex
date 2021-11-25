defmodule Belfrage.Test.MetricsHelper do
  import ExUnit.Assertions

  @doc """
  Asserts that the passed metric is recorded during the execution of the passed
  function.

  The metric can be:
  * Just the name of the event, in which case it's assumed that measurements
  and metadata are empty
  * {event, metadata} tuple
  * {event, measurements, metadata} tuple
  """
  def assert_metric(metric, fun), do: assert_metrics([metric], fun)

  @doc """
  Asserts that the passed metrics are recorded during the execution of the
  passed function. See assert_metric/2 for info on what can be passed as metric
  """
  def assert_metrics(metrics, fun) do
    metrics =
      Enum.map(metrics, fn metric ->
        case metric do
          {event, measurement, metadata} ->
            {prefix_event(event), measurement, metadata}

          {event, metadata} ->
            {prefix_event(event), %{}, metadata}

          event ->
            {prefix_event(event), %{}, %{}}
        end
      end)

    metrics
    |> Enum.map(fn {event, _, _} -> event end)
    |> listen_to_events()

    fun.()

    Enum.each(metrics, fn metric ->
      message = Tuple.insert_at(metric, 0, :telemetry_event)
      assert_receive ^message
    end)
  end

  @doc """
  Asserts that a metric with the passed name is recorded during execution of
  the passed function and returns the metric as a {event, measurements,
  metadata} tuple.
  """
  def intercept_metric(name, fun) do
    event = prefix_event(name)
    listen_to_events([event])
    fun.()
    assert_receive {:telemetry_event, ^event, _measurement, _metatdata} = metric
    Tuple.delete_at(metric, 0)
  end

  defp prefix_event(name) do
    [:belfrage | List.wrap(name)]
  end

  defp listen_to_events(events) do
    self = self()

    :telemetry.attach_many(
      "test-#{UUID.uuid4()}",
      events,
      fn name, measurements, metadata, _ ->
        send(self, {:telemetry_event, name, measurements, metadata})
      end,
      nil
    )
  end
end
