defmodule Routes.Specs.PersonalisedToNonPersonalised do
  def specs() do
    %{
      platform: Webcore,
      request_pipeline: ["PersonalisedToNonPersonalised"],
      personalisation: "test_only"
    }
  end
end
