defmodule BelfrageWeb.Routefile do
  defmacro defroutefile(_name, do: block) do
    quote do
      for env <- unquote(["Test", "Live"]) do
        defmodule apply(BelfrageWeb.Routefile, :module_name, [env]) do
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
end
