defmodule Routes.Specs.WelshNewSearch do
  def specs do
    Map.merge(
        Routes.Specs.WelshNewSearch.specs(),
        %{
           default_language: "cy",
           query_params_allowlist: ["q", "page", "scope", "filter"]
         }
    )
  end
end
