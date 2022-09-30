defmodule Routes.Specs.NewsroundLegacy do
  @moduledoc """
  This RouteSpec is temporary. It exists to have a RouteSpec which
  sends all of its traffic to morph router, to aid the migration of Newsround
  from morph router to webcore.
  """

  def specs do
    %{
      owner: "newsround-development@lists.forge.bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/CE/BBC+Newsround+Run+Book",
      platform: MorphRouter
    }
  end
end
