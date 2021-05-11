defmodule Routefile do
  defmacro defroutefile(_name, do: block) do
    if env != "Sandbox" && Mix.env() != :test do
      quote do
        mn = Module.concat(["Routes", "Routefiles", unquote(env)])

        defmodule mn do
          unquote(block)
        end
      end
    end
  end

  defp env do
    Application.get_env(:belfrage, :production_environment) |> String.capitalize()
  end
end
