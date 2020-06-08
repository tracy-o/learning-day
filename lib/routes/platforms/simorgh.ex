defmodule Routes.Platforms.Simorgh do
  alias Routes.Platforms.Mozart
  def specs(production_env) do
    Map.merge(Mozart.specs(production_env),
    %{
      signature_keys: %{add: [], skip: [:country]}
    })
  end

  def smoke_rules(_env) do
    [
      {%{target: "belfrage"}, :redirects_to, ".com"},
      {%{target: "gtm"}, :redirects_to, ".com"},
      {%{target: "bruce"}, :redirects_to, ".com"},
      {%{target: "cedric"}, :redirects_to, ".com"},
      {%{target: "pal"}, :redirects_to, ".com"},
      {%{target: "preview"}, :redirects_to, ".com"}
    ]
  end
end
