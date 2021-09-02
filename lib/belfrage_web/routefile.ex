defmodule BelfrageWeb.Routefile do
  defmacro defroutefile(_name, do: block) do
    quote do
      for env <- unquote(routefile_envs()) do
        defmodule apply(BelfrageWeb.Routefile, :module_name, [env]) do
          @production_environment env
          unquote(block)
        end
      end
    end
  end

  # This function is needed by the routes mix task otherwise it can go
  def for_cosmos(env) when env in ["test", "live"] do
    Module.concat(["Routes", "Routefiles", String.capitalize(env)])
  end

  def for_cosmos(_env) do
    Module.concat(["Routes", "Routefiles", "Live"])
  end

  def module_name(env) do
    Module.concat(["Routes", "Routefiles", String.capitalize(env)])
  end

  defp routefile_envs do
    if Mix.env() == :dev do
      ["test"]
    else
      ["test", "live"]
    end
  end
end
