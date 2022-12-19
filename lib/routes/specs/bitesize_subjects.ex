defmodule Routes.Specs.BitesizeSubjects do
  def specs(production_env) do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      language_from_cookie: true,
      request_pipeline: pipeline(production_env)
    }
  end

  def pipeline("live"), do: ["ComToUKRedirect", "BitesizeSubjectsPlatformDiscriminator", "LambdaOriginAlias", "Language"]
  def pipeline(_production_env), do: pipeline("live")
end
