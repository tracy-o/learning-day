defmodule Belfrage.Dials.Config do
  require Logger

  @spec decode({String.t(), String.t()} | map()) :: [{atom(), term()}]
  def decode(dials) when is_map(dials) do
    Enum.reduce(dials, [], fn dial, acc ->
      case decode(dial) do
        nil -> acc
        decoded -> [decoded | acc]
      end
    end)
  end

  def decode({"bbcx_enabled", "true"}), do: {:bbcx_enabled, true}
  def decode({"bbcx_enabled", "false"}), do: {:bbcx_enabled, false}

  def decode({"cache_enabled", "true"}), do: {:cache_enabled, true}
  def decode({"cache_enabled", "false"}), do: {:cache_enabled, false}

  def decode({"ccp_enabled", "true"}), do: {:ccp_enabled, true}
  def decode({"ccp_enabled", "false"}), do: {:ccp_enabled, false}

  def decode({"circuit_breaker", "true"}), do: {:circuit_breaker, true}
  def decode({"circuit_breaker", "false"}), do: {:circuit_breaker, false}

  def decode({"mvt_enabled", "true"}), do: {:mvt_enabled, true}
  def decode({"mvt_enabled", "false"}), do: {:mvt_enabled, false}

  def decode({"election_banner_council_story", "on"}), do: {:election_banner_council_story, "on"}
  def decode({"election_banner_council_story", "off"}), do: {:election_banner_council_story, "off"}

  def decode({"election_banner_ni_story", "on"}), do: {:election_banner_ni_story, "on"}
  def decode({"election_banner_ni_story", "off"}), do: {:election_banner_ni_story, "off"}

  def decode({"ni_election_failover", "on"}), do: {:ni_election_failover, "on"}
  def decode({"ni_election_failover", "off"}), do: {:ni_election_failover, "off"}

  def decode({"obit_mode", "on"}), do: {:obit_mode, "on"}
  def decode({"obit_mode", "off"}), do: {:obit_mode, "off"}

  def decode({"football_scores_fixtures", "mozart"}), do: {:football_scores_fixtures, "mozart"}
  def decode({"football_scores_fixtures", "webcore"}), do: {:football_scores_fixtures, "webcore"}

  def decode({"logging_level", level}) when level in ["debug", "info", "warn", "error"],
    do: {:logging_level, String.to_atom(level)}

  def decode({"news_apps_hardcoded_response", "enabled"}), do: {:news_apps_hardcoded_response, true}
  def decode({"news_apps_hardcoded_response", "disabled"}), do: {:news_apps_hardcoded_response, false}

  def decode({"news_apps_variance_reducer", "enabled"}), do: {:news_apps_variance_reducer, true}
  def decode({"news_apps_variance_reducer", "disabled"}), do: {:news_apps_variance_reducer, false}

  def decode({"news_articles_personalisation", "on"}), do: {:news_articles_personalisation, true}
  def decode({"news_articles_personalisation", "off"}), do: {:news_articles_personalisation, false}

  def decode({"personalisation", "on"}), do: {:personalisation, true}
  def decode({"personalisation", "off"}), do: {:personalisation, false}

  def decode({"webcore_kill_switch", "active"}), do: {:webcore_kill_switch, true}
  def decode({"webcore_kill_switch", "inactive"}), do: {:webcore_kill_switch, false}

  def decode({"non_webcore_ttl_multiplier", "very-short"}), do: {:non_webcore_ttl_multiplier, 0.5}
  def decode({"non_webcore_ttl_multiplier", "short"}), do: {:non_webcore_ttl_multiplier, 0.75}
  def decode({"non_webcore_ttl_multiplier", "default"}), do: {:non_webcore_ttl_multiplier, 1}
  def decode({"non_webcore_ttl_multiplier", "long"}), do: {:non_webcore_ttl_multiplier, 2}
  def decode({"non_webcore_ttl_multiplier", "very-long"}), do: {:non_webcore_ttl_multiplier, 4}
  def decode({"non_webcore_ttl_multiplier", "longest"}), do: {:non_webcore_ttl_multiplier, 6}

  def decode({"webcore_ttl_multiplier", "very-short"}), do: {:webcore_ttl_multiplier, 1 / 3}
  def decode({"webcore_ttl_multiplier", "short"}), do: {:webcore_ttl_multiplier, 2 / 3}
  def decode({"webcore_ttl_multiplier", "default"}), do: {:webcore_ttl_multiplier, 1}
  def decode({"webcore_ttl_multiplier", "long"}), do: {:webcore_ttl_multiplier, 6}
  def decode({"webcore_ttl_multiplier", "very-long"}), do: {:webcore_ttl_multiplier, 12}
  def decode({"webcore_ttl_multiplier", "longest"}), do: {:webcore_ttl_multiplier, 24}

  def decode(dial) do
    Logger.log(:error, "Dial #{inspect(dial)} cannot be handled and will be ignored")
    nil
  end

  @spec action({String.t(), String.t()} | map()) :: :ok
  def action(dials) when is_map(dials) do
    for dial <- dials, do: action(dial)
    :ok
  end

  def action({"logging_level", level}) when level in ["debug", "info", "warn", "error"] do
    logger_opts =
      Application.get_env(:logger, :file)
      |> Keyword.put(:level, String.to_atom(level))

    Logger.configure_backend({LoggerFileBackend, :file}, logger_opts)
  end

  def action(_dial), do: :ok
end
