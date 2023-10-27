defmodule Routes.SpecExamplesTest do
  use ExUnit.Case
  use Plug.Test

  test "both preflight platforms match existing platforms" do
    preflight_module_names
    |> IO.inspect()
    |> validate(&validate_platforms/1)
  end

  defp preflight_module_names do
    {:ok, modules} = :application.get_key(:belfrage, :modules)

    modules
    |> Enum.map(&Module.split/1)
    |> Enum.filter(fn list -> List.starts_with?(list, ["Belfrage", "PreflightTransformers"]) end)
    |> Enum.map(&List.last/1)
    |> Enum.uniq()
  end

  defp validate_platforms(transformer_name) do
    platform_names = get_platform_names()

    path = trans_src(transformer_name)
    {:ok, original} = File.read(path)

    for spec <- specs_specs do
      if Enum.member?(platform_names, spec.platform) do
        :ok
      else
        {:error, "Platform #{spec.platform} for is not spelled correctly"}
      end
    end
  end

  defp trans_src(transformer_name) do
    module = Module.concat([Routes, Specs, transformer_name])
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
