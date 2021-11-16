defmodule Belfrage.Test.MetricsHelper do
  import ExUnit.Assertions

  @doc """
  Asserts that the passed event, with no measurements and no metadata,
  is recorded during the execution of the passed function.
  """
  def assert_event(name, fun), do: assert_metric({name, %{}, %{}}, fun)

  @doc """
  Asserts that the passed metric is recorded during the execution of the passed
  function.
  """
  def assert_metric(metric, fun), do: assert_metrics(List.wrap(metric), fun)

  @doc """
  Asserts that the passed metrics are recorded during the execution of the
  passed function.
  """
  def assert_metrics(metrics, fun) do
    metrics = Enum.map(metrics, fn {event, measurement, metadata} -> {prefix_event(event), measurement, metadata} end)

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
