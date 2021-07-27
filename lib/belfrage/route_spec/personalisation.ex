defmodule Belfrage.RouteSpec.Personalisation do
  @allow_personalisation_map %{cookie_allowlist: ["ckns_atkn", "ckns_id"], headers_allowlist: ["x-id-oidc-signedin"]}

  def personalised?(loop_id) when not is_map(loop_id) do
    personalised?(Belfrage.RouteSpec.specs_for(loop_id))
  end

  def personalised?(route_specs) do
    case route_specs[:personalisation] do
      "on" -> true
      "test_only" -> production_environment() == "test"
      _ -> false
    end
  end

  def maybe_interpolate_personalisation(route_specs) do
    if personalised?(route_specs) do
      Map.merge(route_specs, @allow_personalisation_map, &merge_key/3)
    else
      route_specs
    end
  end

  defp merge_key(_key, value1, value2) do
    value1 ++ value2
  end

  defp production_environment() do
    Application.get_env(:belfrage, :production_environment)
  end
end
