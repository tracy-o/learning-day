import Config

config :belfrage,
  dial_handlers: %{
    "circuit_breaker" => Belfrage.Dials.CircuitBreaker,
    "webcore_ttl_multiplier" => Belfrage.Dials.WebcoreTtlMultiplier,
    "non_webcore_ttl_multiplier" => Belfrage.Dials.NonWebcoreTtlMultiplier,
    "logging_level" => Belfrage.Dials.LoggingLevel,
    "personalisation" => Belfrage.Dials.Personalisation,
    "news_articles_personalisation" => Belfrage.Dials.NewsArticlesPersonalisation,
    "obit_mode" => Belfrage.Dials.ObitMode,
    "ccp_enabled" => Belfrage.Dials.CcpEnabled,
    "webcore_kill_switch" => Belfrage.Dials.WebcoreKillSwitch,
    "chameleon" => Belfrage.Dials.Chameleon,
    "cache_enabled" => Belfrage.Dials.CacheEnabled,
    "mvt_enabled" => Belfrage.Dials.MvtEnabled,
    "election_banner_ni_story" => Belfrage.Dials.ElectionBannerNiStory,
    "election_banner_council_story" => Belfrage.Dials.ElectionBannerCouncilStory
  }
