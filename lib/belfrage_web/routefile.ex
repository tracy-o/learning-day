defmodule BelfrageWeb.Routefile do
  defmacro defroutefile(_name, do: block) do
    if not_running_unit_tests() do
      quote do
        defmodule unquote(module_name()) do
          unquote(block)
        end
      end
    end
  end

  def for_cosmos(env) do
    Module.concat(["Routes", "Routefiles", String.capitalize(env)])
  end

  defp module_name do
    cosmos_env() |> for_cosmos()
  end

  defp cosmos_env do
    Application.get_env(:belfrage, :production_environment)
  end

  defp not_running_unit_tests do
    cosmos_env() != "sandbox" && Mix.env() != :test
  end
end
