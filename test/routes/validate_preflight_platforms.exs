defmodule Routes.SpecExamplesTest do
  use ExUnit.Case
  use Plug.Test

  test "both preflight platforms match existing platforms" do
    preflight_transformers
    |> Enum.reject(fn x -> Kernel.length(x.specs) == 1 end)
    |> IO.inspect()
    |> validate(&validate_platforms/1)
  end

  defp preflight_transformers do
    {:ok, modules} = :application.get_key(:belfrage, :modules)

    modules
    |> Enum.map(&Module.split/1)
    |> Enum.filter(fn list -> List.starts_with?(list, ["Belfrage", "PreflightTransformers"]) end)
    |> Enum.map(&List.last/1)
    |> Enum.uniq()
  end

  defp spec_src(spec_name) do
    module = Module.concat([Routes, Specs, spec_name])
    module.__info__(:compile)[:source]
  end

  defp validate(items, validator) do
    errors =
      items
      |> Enum.map(validator)
      |> Enum.reduce([], fn el, acc ->
        case el do
          {:error, error} ->
            IO.inspect(error)
            [error | acc]

          _ ->
            acc
        end
      end)

    IO.inspect(errors)

    unless errors == [] do
      errors
      |> List.flatten()
      |> Enum.map_join("\n", &"* #{&1}")
      |> flunk()
    end
  end

  defp validate_platforms(route_spec) do
    platform_names = get_platform_names()

    specs_specs = route_spec.specs

    for spec <- specs_specs do
      if Enum.member?(platform_names, spec.platform) do
        :ok
      else
        {:error, "Platform #{spec.platform} for is not spelled correctly"}
      end
    end
  end

  defp handle_error(platform_names, platform) do
    # calculate jaro distance
    # add a suggestion

    {:error, "Platform #{platform} is not spelled correctly"}
  end

  defp get_platform_names() do
    {:ok, modules} = :application.get_key(:belfrage, :modules)

    modules
    |> Enum.map(&Module.split/1)
    |> Enum.filter(fn list -> List.starts_with?(list, ["Routes", "Platforms"]) end)
    |> Enum.map(&List.last/1)
    |> Enum.uniq()
  end
end
