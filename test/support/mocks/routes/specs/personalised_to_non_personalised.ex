defmodule Routes.Specs.PersonalisedToNonPersonalised do
  def specification do
    %{
      specs: %{
        platform: "Webcore",
        request_pipeline: ["PersonalisedToNonPersonalised"],
        personalisation: "test_only"
      }
    }
  end
end
