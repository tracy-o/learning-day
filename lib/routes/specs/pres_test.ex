defmodule Routes.Specs.PresTest do
  def specs do
    %{
      owner: "simon.scarfe@bbc.co.uk",
      platform: Webcore,
      query_params_allowlist: ["q", "page", "scope", "filter"]
    }
  end
end
