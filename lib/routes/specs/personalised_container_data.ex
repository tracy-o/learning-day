defmodule Routes.Specs.PersonalisedContainerData do
  def specification do
    %{
      specs: %{
        platform: "Webcore",
        query_params_allowlist: "*",
        personalisation: "on",
        examples: []
      }
    }
  end
end
