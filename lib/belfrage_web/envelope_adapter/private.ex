defmodule BelfrageWeb.EnvelopeAdapter.Private do
  alias Belfrage.Envelope

  def adapt(envelope = %Envelope{}, private, route_state_id) do
    Envelope.add(envelope, :private, %{
      route_state_id: route_state_id,
      overrides: private.overrides,
      production_environment: private.production_environment,
      preview_mode: private.preview_mode
    })
  end
end
