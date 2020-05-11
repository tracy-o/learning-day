defmodule Routes.Platforms.Simorgh do
  alias Routes.Platforms.Mozart
  def specs(production_env) do
    Map.merge(Mozart.specs(production_env),
    %{
      remove_signature_keys: [:country]
    })
  end
end
