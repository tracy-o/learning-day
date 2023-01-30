defmodule Belfrage.Xray.Enable do
  alias Belfrage.Struct

  # If in a routespec or platform we set:
  #   xray_enabled: true
  #
  # It will trigger this piece of code which removes the `xray_segment` from the
  # struct. All code that touches `xray_segment` is also prepared to handle a
  # `nil` value.
  def call(struct = %Struct{}) do
    if struct.private.xray_enabled do
      struct
    else
      Struct.add(struct, :request, %{xray_segment: nil})
    end
  end
end
