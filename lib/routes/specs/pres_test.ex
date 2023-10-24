defmodule Routes.Specs.PresTest do
  def specification do
    %{
      specs: %{
        email: "D&EWebCorePresentationTeam@bbc.co.uk",
        platform: "Webcore",
        language_from_cookie: true,
        query_params_allowlist: "*"
      }
    }
  end
end
