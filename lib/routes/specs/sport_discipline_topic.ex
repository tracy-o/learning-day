defmodule Routes.Specs.SportDisciplineTopic do
  def specification do
    %{
      specs: %{
        email: "DEHomepageTopicsOnCallTeam@bbc.co.uk",
        runbook: "https://confluence.dev.bbc.co.uk/display/DPTOPICS/Topics+Runbook",
        platform: "Webcore",
        query_params_allowlist: ["page"],
        personalisation: "on",
        examples: ["/sport/wrestling", "/sport/weightlifting", "/sport/water-polo", "/sport/volleyball", "/sport/triathlon", "/sport/taekwondo", "/sport/table-tennis", "/sport/synchronised-swimming", "/sport/sustainability", "/sport/surfing", "/sport/squash", "/sport/sport-climbing", "/sport/speed-skating", "/sport/snowboarding", "/sport/ski-jumping", "/sport/skeleton", "/sport/skateboarding", "/sport/short-track-skating", "/sport/shooting", "/sport/sailing", "/sport/rugby-sevens", "/sport/rowing", "/sport/nordic-combined", "/sport/modern-pentathlon", "/sport/luge", "/sport/karate", "/sport/judo", "/sport/insight", "/sport/ice-hockey", "/sport/hockey", "/sport/handball", "/sport/gymnastics", "/sport/freestyle-skiing", "/sport/figure-skating", "/sport/fencing", "/sport/equestrian", "/sport/diving", "/sport/darts", "/sport/curling", "/sport/cross-country-skiing", "/sport/canoeing", "/sport/bowls", "/sport/bobsleigh", "/sport/biathlon", "/sport/baseball", "/sport/badminton", "/sport/archery", "/sport/alpine-skiing"]
      }
    }
  end
end
