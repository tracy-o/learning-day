defmodule Routes.Specs.WorldServiceVietnameseTopicPage do
  def specs(production_env) do
    %{
      platform: Simorgh,
      pipeline: pipeline(production_env),
      query_params_allowlist: ["page"]
    }
  end
end
