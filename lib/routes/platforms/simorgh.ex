defmodule Routes.Platforms.Simorgh do
  alias Routes.Platforms.Mozart
  def specs(production_env) do
    Map.merge(Mozart.specs(production_env),
    %{
      signature_keys: %{add: [], skip: [:country]}
    })
  end
end
