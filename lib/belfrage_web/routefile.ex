defmodule Routefile do
  defmacro defroutefile(_name, do: block) do
    if cosmos_env() != "Sandbox" && Mix.env() != :test do
      quote do
        defmodule unquote(module_name()) do
          unquote(block)
        end
      end
    end
  end

  defp module_name do
    Module.concat(["Routes", "Routefiles", cosmos_env()])
  end

  defp cosmos_env do
    Application.get_env(:belfrage, :production_environment) |> String.capitalize()
  end
end
