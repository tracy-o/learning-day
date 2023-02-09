defmodule Belfrage.Xray.Enable do
  alias Belfrage.Envelope

  # If in a routespec or platform we set:
  #   xray_enabled: true
  #
  # It will trigger this piece of code which removes the `xray_segment` from the
  # envelope. All code that touches `xray_segment` is also prepared to handle a
  # `nil` value.
  def call(envelope = %Envelope{}) do
    if envelope.private.xray_enabled do
      envelope
    else
      Envelope.add(envelope, :request, %{xray_segment: nil})
    end
  end
end
