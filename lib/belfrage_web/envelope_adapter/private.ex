defmodule BelfrageWeb.EnvelopeAdapter.Private do
  alias Belfrage.Envelope

  def adapt(envelope = %Envelope{}, private, spec) do
    Envelope.add(envelope, :private, %{
      spec: spec,
      overrides: private.overrides,
      production_environment: private.production_environment,
      preview_mode: private.preview_mode
    })
  end
end
