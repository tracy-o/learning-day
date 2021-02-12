defmodule Routes.Platforms.Simorgh do
  alias Routes.Platforms.MozartNews
  def specs(production_env) do
    Map.merge(MozartNews.specs(production_env),
    %{
      signature_keys: %{add: [], skip: [:country]}
    })
  end
end
