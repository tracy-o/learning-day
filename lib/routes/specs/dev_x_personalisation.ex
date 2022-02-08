defmodule Routes.Specs.DevXPersonalisation do
  def specs do
    %{
      owner: "devx@bbc.co.uk",
      platform: Webcore,
      query_params_allowlist: ["personalisationMode"],
      personalisation: "test_only"
    }
  end
end
