defmodule Routes.Platforms.Simorgh do
  alias Routes.Platforms.MozartNews
  def specs(production_env) do
    Map.merge(MozartNews.specs(production_env),
    %{
      signature_keys: %{add: [:is_advertise], skip: [:country]}
    })
  end
end
