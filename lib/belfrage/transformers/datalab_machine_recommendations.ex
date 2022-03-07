defmodule Belfrage.Transformers.DatalabMachineRecommendations do
  use Belfrage.Transformers.Transformer

  alias Belfrage.Struct
  alias Belfrage.Struct.Private

  @dial Application.get_env(:belfrage, :dial)

  @impl true
  def call(rest, struct = %Struct{private: private = %Private{}}) do
    value = if @dial.state(:datalab_machine_recommendations), do: "enabled", else: "disabled"

    struct =
      Struct.add(struct, :private, %{features: Map.put(private.features, :datalab_machine_recommendations, value)})

    then_do(rest, struct)
  end
end
