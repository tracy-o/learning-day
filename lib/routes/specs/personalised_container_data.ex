defmodule Routes.Specs.PersonalisedContainerData do
  def specs do
    %{
      platform: Webcore,
      query_params_allowlist: "*",
      personalisation: "test_only"
    }
  end
end
