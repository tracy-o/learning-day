defmodule Routes.Specs.TopicPage do
  def specs do
    %{
      owner: "D&EKLDevelopmentOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
      platform: Webcore
    }
  end

  def sports_topics_routes do
    [
      "alpine-skiing",
      "biathlon",
      "bobsleigh",
      "cross-country-skiing",
      "curling",
      "figure-skating",
      "freestyle-skiing",
      "luge",
      "nordic-combined",
      "short-track-skating",
      "skeleton",
      "ski-jumping",
      "snowboarding",
      "speed-skating",
      "rugby-sevens"
    ]
  end
end
