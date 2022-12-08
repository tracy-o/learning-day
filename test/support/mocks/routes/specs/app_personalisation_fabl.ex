defmodule Routes.Specs.AppPersonalisationFabl do
  def specs(env) do
    %{
      platform: Fabl,
      personalisation: "on",
      request_pipeline: request_pipeline(env)
    }
  end

  defp request_pipeline("live"), do: []

  defp request_pipeline(_env), do: ["AppPersonalisation"]
end
