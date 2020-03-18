defmodule Routes.Specs.PageComposition do
  def specs do
    %{
      platform: Webcore,
      query_params_allowlist: ["path", "params"]
    }
  end
end
