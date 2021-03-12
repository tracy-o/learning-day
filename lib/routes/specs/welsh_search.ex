defmodule Routes.Specs.WelshSearch do
  def specs(production_env) do
    Map.merge(Routes.Specs.Search.specs(production_env), %{default_language: "cy"})
  end
end
