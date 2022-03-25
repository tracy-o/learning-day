defmodule Routes.Specs.PersonalisedFablData do
  def specs(production_env) do
    %{
      platform: Fabl,
      personalisation: "test_only"
    }
  end
end
