defmodule Routes.Specs.WorldServiceTajik do
  def specs do
    %{
      platform: MozartNews,
      pipeline: ["WorldServiceRedirect"],
      query_params_allowlist: ["alternativeJsLoading", "batch"]
    }
  end
end
