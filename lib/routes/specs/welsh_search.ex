defmodule Routes.Specs.WelshSearch do
  def specs do
    Map.merge(Routes.Specs.Search.specs(), %{default_language: "cy"})
  end
end
