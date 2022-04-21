defmodule Routes.Specs.PersonalisedToNonPersonalised do
  def specs() do
    %{
      platform: Webcore,
      pipeline: ["PersonalisedToNonPersonalised"],
      personalisation: "test_only"
    }
  end
end
