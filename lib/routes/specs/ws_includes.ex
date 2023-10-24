defmodule Routes.Specs.WsIncludes do
  def specification do
    %{
      specs: %{
        email: "DENewsFrameworksTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/BELFRAGE/Belfrage+Run+Book",
        platform: "MozartNews",
        query_params_allowlist: ["alternativeJsLoading", "amp", "batch", "before", "category_site", "component_id", "components", "config_path", "embeddingPageTitle", "embeddingPageUri", "id", "lang", "options", "page", "presenter", "ptrt", "q", "redirect_location", "s", "search", "service", "show-service-calls", "start", "ticker", "anchor"],
        examples: ["/ws/includes/include/vjamericas/176-eclipse-lookup/mundo/app/embed"]
      }
    }
  end
end
