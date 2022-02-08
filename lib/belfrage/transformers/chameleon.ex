defmodule Belfrage.Transformers.Chameleon do
  use Belfrage.Transformers.Transformer

  alias Belfrage.Struct
  alias Belfrage.Struct.Private

  @dial Application.get_env(:belfrage, :dial)

  @impl true
  def call(rest, struct = %Struct{private: private = %Private{}}) do
    value = @dial.state(:chameleon)
    struct = Struct.add(struct, :private, %{features: Map.put(private.features, :chameleon, value)})

    then(rest, struct)
  end
end
