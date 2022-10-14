defmodule BelfrageWeb.StructAdapter.Private do
  alias Belfrage.Struct

  def adapt(struct = %Struct{}, private, route_state_id) do
    Struct.add(struct, :private, %{
      route_state_id: route_state_id,
      overrides: private.overrides,
      production_environment: private.production_environment,
      preview_mode: private.preview_mode
    })
  end
end
