defmodule Belfrage.Transformers.MetricTester do
  use Belfrage.Transformers.Transformer

  @impl true
  def call(rest, struct) do
    Belfrage.Metrics.Statix.increment("joes.test.increment")
    Belfrage.Metrics.Statix.timing("joes.test.timing", 52)
    {:stop_pipeline, struct}
  end
end
