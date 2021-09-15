defmodule Belfrage.Test.MetricsHelper do
  import ExUnit.Assertions

  @doc """
  Assert that the passed metric is recorded during the execution of the passed
  function.
  """
  def assert_metric(metric, fun), do: assert_metrics(List.wrap(metric), fun)

  @doc """
  Assert that the passed metrics are recorded during the execution of the
  passed function.
  """
  def assert_metrics(metrics, fun) do
    metrics = Enum.map(metrics, fn {event, measurement, metadata} -> {[:belfrage | event], measurement, metadata} end)
    events = Enum.map(metrics, fn {event, _, _} -> event end)
    self = self()

    :telemetry.attach_many(
      "test-#{UUID.uuid4()}",
      events,
      fn name, measurements, metadata, _ ->
        send(self, {:telemetry_event, name, measurements, metadata})
      end,
      nil
    )

    fun.()

    Enum.each(metrics, fn metric ->
      message = Tuple.insert_at(metric, 0, :telemetry_event)
      assert_receive ^message
    end)
  end
end
