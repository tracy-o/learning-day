defmodule BelfrageWeb.Routefile do
  defmacro defroutefile(name, do: block) do
    quote do
      for env <- unquote(routefile_envs()) do
        defmodule Module.concat(["Routes", "Routefiles", String.capitalize(unquote(name)), String.capitalize(env)]) do
          @production_environment env
          import BelfrageWeb.Validators
          use BelfrageWeb.RouteMaster
          unquote(block)
        end
      end
    end
  end

  defmacro defroutefile(name, env, do: block) do
    quote do
      defmodule Module.concat(["Routes", "Routefiles", unquote(name)]) do
        @production_environment unquote(env)
        import BelfrageWeb.Validators
        use BelfrageWeb.RouteMaster
        unquote(block)
      end
    end
  end

  # This function is needed by the routes mix task otherwise it can go
  def for_cosmos(env) when env in ["test", "live"] do
    Module.concat(["Routes", "Routefiles", "Main", String.capitalize(env)])
  end

  def for_cosmos(_env) do
    Module.concat(["Routes", "Routefiles", "Main", "Live"])
  end

  defp routefile_envs do
    if Mix.env() == :dev do
      ["test"]
    else
      ["test", "live"]
    end
  end
end
