defmodule Routes.Specs.WelshNewSearch do
  def specs do
    Map.merge(Routes.Specs.WelshNewSearch.specs(), %{default_language: "cy"})
  end
end
