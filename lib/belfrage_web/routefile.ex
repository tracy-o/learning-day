defmodule BelfrageWeb.Routefile do
  defmacro defroutefile(_name, do: block) do
    quote do
      defmodule unquote(module_name()) do
        unquote(block)
      end
    end
  end

  def for_cosmos(env) when env in ["test", "live"] do
    Module.concat(["Routes", "Routefiles", String.capitalize(env)])
  end

  def for_cosmos(_env) do
    Module.concat(["Routes", "Routefiles", "Live"])
  end

  defp module_name do
    cosmos_env() |> for_cosmos()
  end

  defp cosmos_env do
    Application.get_env(:belfrage, :production_environment)
  end
end
