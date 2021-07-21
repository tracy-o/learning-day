defmodule Belfrage.Dials.WebcoreTtlMultiplier do
  @moduledoc false

  @behaviour Belfrage.Dial

  @impl Belfrage.Dial
  def transform(ttl_value) do
    case ttl_value do
      "0.5x" -> 0.5
      "0.8x" -> 0.8
      "1x" -> 1
      "2x" -> 2
      "4x" -> 4
    end
  end
end
