defmodule Routes.Specs.Moz do
  def specs do
    %{
      platform: MozartNews,
      query_params_allowlist: ["only_allow_this_on_live"]
    }
  end
end
