defmodule Routes.Specs.WorldServiceTigrinyaAssets do
  def specs(production_env) do
    %{
      platform: Simorgh,
      pipeline: pipeline(production_env),
    }
  end
end
