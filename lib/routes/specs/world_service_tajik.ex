defmodule Routes.Specs.WorldServiceTajik do
  def specs(production_env) do
    %{
      platform: MozartNews,
      pipeline: pipeline(production_env),
      query_params_allowlist: ["alternativeJsLoading", "batch"]
    }
  end

  defp pipeline(_production_env), do: ["WorldServiceRedirect"]
end
