defmodule BelfrageWeb.Routefile do
  defmacro defroutefile(_name, do: block) do
    quote do
      for env <- unquote(module_envs()) do
        defmodule apply(BelfrageWeb.Routefile, :module_name, [env]) do
          unquote(block)
        end
      end
    end
  end

  def module_name(env) do
    Module.concat(["Routes", "Routefiles", String.capitalize(env)])
  end

  def module_envs do
    case cosmos_env() do
      "test" -> ["Test", "Live"]
      _ -> ["Live"]
    end
  end

  defp cosmos_env do
    Application.get_env(:belfrage, :production_environment)
  end
end
