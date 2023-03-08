defmodule Routes.Specs.Selectors.FailingSpecSelector do
  @behaviour Belfrage.Behaviours.Selector

  @impl true
  def call(_) do
    {:error, 500}
  end
end
