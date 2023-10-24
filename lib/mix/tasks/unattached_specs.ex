defmodule Mix.Tasks.UnattachedSpecs do
  use Mix.Task

  @doc """
  Finds Specs modules that are not attached to a route in any Routefile.
  These Specs might have been used in the past, but are no longer used,
  and have now become unattached (i.e. "zombies")

  ## Example
  iex> Mix.Tasks.UnattachedSpecs.run([])
  {:ok,
    %{
      unattached_specs: [
        %{unattached_spec: "KarangaTest"},
        %{unattached_spec: "SomeWorldServiceRouteState"},
        %{unattached_spec: "WeatherCps"},
        %{...},
        ...
      ]
    }
  }
  """

  def run([]) do
    IO.puts("# Belfrage - Find Unattached Specs\n")

    spec_modules = get_spec_modules()
    route_specs = get_route_specs()

    {:ok,
       %{unattached_specs: find_unattached_specs(spec_modules, route_specs)}
    }
  end

  defp get_spec_modules() do
    {:ok, modules} = :application.get_key(:belfrage, :modules)

    modules
      |> Enum.map(&Module.split/1)
      |> Enum.filter(fn list -> List.starts_with?(list, ["Routes", "Specs"]) end)
      |> Enum.map(&List.last/1)
  end

  defp get_route_specs() do
    main_routefile  = Routes.Routefiles.Main.Test
    sport_routefile = Routes.Routefiles.Sport.Test
    mock_routefile  = Routes.Routefiles.Mock

    combined_routefiles = main_routefile.routes() ++ sport_routefile.routes() ++ mock_routefile.routes()

    combined_routefiles
    |> Enum.reduce([], fn route, acc -> get_route_maps(route) ++ acc end)
  end

  defp get_route_maps({route_matcher, %{using: spec_name, only_on: only_on}}) do

    %{specs: specs} = Belfrage.RouteSpec.get_route_spec(spec_name)

    for spec <- specs, do: %{
      route: route_matcher,
      spec: spec_name,
      platform: spec.platform,
      email: spec.email,
      slack_channel: spec.slack_channel,
      team: spec.team,
      env: only_on || "live"}
  end

  def find_unattached_specs(spec_modules, route_specs) do
    filtered_route_specs = Enum.map(route_specs, fn route_spec -> route_spec.spec end)
    spec_modules -- filtered_route_specs
  end
end
