import Config

config :belfrage,
  dial_handlers: %{
    "cache_enabled" => Belfrage.Dials.CacheEnabled,
    "ccp_enabled" => Belfrage.Dials.CcpEnabled,
    "circuit_breaker" => Belfrage.Dials.CircuitBreaker,
    "election_banner_council_story" => Belfrage.Dials.ElectionBannerCouncilStory,
    "election_banner_ni_story" => Belfrage.Dials.ElectionBannerNiStory,
    "football_scores_fixtures" => Belfrage.Dials.FootballScoresFixtures,
    "logging_level" => Belfrage.Dials.LoggingLevel,
    "mvt_enabled" => Belfrage.Dials.MvtEnabled,
    "news_apps_hardcoded_response" => Belfrage.Dials.NewsAppsHardcodedResponse,
    "news_apps_variance_reducer" => Belfrage.Dials.NewsAppsVarianceReducer,
    "news_articles_personalisation" => Belfrage.Dials.NewsArticlesPersonalisation,
    "non_webcore_ttl_multiplier" => Belfrage.Dials.NonWebcoreTtlMultiplier,
    "obit_mode" => Belfrage.Dials.ObitMode,
    "personalisation" => Belfrage.Dials.Personalisation,
    "webcore_kill_switch" => Belfrage.Dials.WebcoreKillSwitch,
    "webcore_ttl_multiplier" => Belfrage.Dials.WebcoreTtlMultiplier
  }
