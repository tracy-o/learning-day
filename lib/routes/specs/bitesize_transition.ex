defmodule Routes.Specs.BitesizeTransition do
  @moduledoc """
  This RouteSpec is temporary. It exists because of a requirement in
  https://jira.dev.bbc.co.uk/browse/RESFRAME-4439 to have a RouteSpec which goes to
  different origins depending on environment, to aid the migration of bitesize
  from morph router to webcore.
  """


  def specs("live") do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: MorphRouter,
      pipeline: ["ComToUKRedirect"],
      language_from_cookie: true
    }
  end

  def specs(_production_env) do
    %{
      owner: "bitesize-production@lists.forge.bbc.co.uk",
      platform: Webcore,
      pipeline: ["ComToUKRedirect"],
      language_from_cookie: true
    }
  end
end
