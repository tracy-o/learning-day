defmodule Routes.Specs.AppPersonalisation do
  def specification(env) do
    %{
      specs: %{
        platform: "Fabl",
        personalisation: "on",
        request_pipeline: request_pipeline(env)
      }
    }
  end

  defp request_pipeline("live"), do: []

  defp request_pipeline(_env), do: ["AppPersonalisationHalter"]
end
