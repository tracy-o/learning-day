defmodule Belfrage.Dials.TtlMultiplier do
  alias Belfrage.Dials.Poller

  @ttl_modifier_comparison %{
    "private" => 0,
    "default" => 1,
    "long" => 3,
    "super_long" => 10
  }

  def value() do
    Poller.state()
    |> Map.get("ttl_multiplier", "default")
    |> dial_value_to_int()
  end

  defp dial_value_to_int(dial_value) do
    Map.get(@ttl_modifier_comparison, dial_value, 1)
  end
end
