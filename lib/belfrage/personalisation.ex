defmodule Belfrage.RouteSpec.Personalisation do
  @allow_personalisation_map %{cookie_allowlist: ["ckns_atkn", "ckns_id"], headers_allowlist: ["x-id-oidc-signedin"]}

  defp production_environment() do
    Application.get_env(:belfrage, :production_environment)
  end

  def maybe_interpolate_personalisation(route_specs) do
    if personalisation_enabled?(route_specs) do
      route_specs
      |> Map.merge(@allow_personalisation_map, &merge_key/3)
    else
      route_specs
    end
  end

  defp merge_key(_key, value1, value2) do
    value1 ++ value2
  end

  def personalisation_enabled?(loop_id) when not is_map(loop_id) do
    personalisation_enabled?(Belfrage.RouteSpec.specs_for(loop_id))
  end

  def personalisation_enabled?(route_specs) do
    case route_specs[:personalisation] do
      "on" -> true
      "test_only" -> production_environment() == "test"
      _ -> false
    end
  end
end
