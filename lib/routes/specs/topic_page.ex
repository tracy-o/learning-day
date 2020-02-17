defmodule Routes.Specs.TopicPage do
  def specs do
    %{
      owner: "D&EKLDevelopmentOnCallTeam@bbc.co.uk",
      runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
      platform: :webcore,
      pipeline: ["HTTPredirect", "DevelopmentRequests", "LambdaOriginAlias", "CircuitBreaker"],
      resp_pipeline: [],
      circuit_breaker_error_threshold: 100
    }
  end

  def existing_topics_ids do
    [
      "c7gj2g87ez8t",  # Alpine Skiing
      "c9em2e59y83t",  # Biathlon
      "c85z25g35kdt",  # Bobsleigh
      "c7gj2g8l8qdt",  # Cross Country Skiiing
      "c2yx2y7q8x0t",  # Curling
      "cv7dr79gjjet",  # Figure Skating
      "cmj5ljxk69yt",  # Freestyle Skiing
      "c2yx2y9qgr0t",  # Luge
      "c53gk34rmlkt",  # Nordic Combined
      "c0mz5mvjj09t",  # Short Track Skating
      "cezpvz7y3g6t",  # Skeleton
      "ck0r604dlrzt",  # Ski Jumping
      "cezpvzp93m5t",  # Snowboarding
      "c3dr5drg040t",  # Speed Skating
      "clmq6mqqdpqt",  # Rugby Sevens
    ]
  end
end
