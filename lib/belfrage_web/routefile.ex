defmodule Routefile do
  defmacro defroutefile(_name, do: block) do
    env = Application.get_env(:belfrage, :production_environment) |> String.capitalize
    if env != "Sandbox" do
      quote do
        mn = Module.concat(["Routes", "Routefiles", unquote(env)])
        defmodule mn do
          unquote(block)
        end
      end
    end
  end
end
