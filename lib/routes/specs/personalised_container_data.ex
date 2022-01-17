defmodule Routes.Specs.PersonalisedContainerData do
  def specs do
    %{
      platform: Webcore,
      query_params_allowlist: "*",
      personalisation: "on"
    }
  end
end
