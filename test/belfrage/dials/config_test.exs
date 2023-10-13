defmodule Belfrage.Dials.ConfigTest do
  use ExUnit.Case, async: true

  alias Belfrage.Dials.Config

  @default_dials %{
    "bbcx_enabled" => "true",
    "cache_enabled" => "true",
    "ccp_enabled" => "true",
    "circuit_breaker" => "false",
    "election_banner_council_story" => "off",
    "election_banner_ni_story" => "off",
    "football_scores_fixtures" => "mozart",
    "logging_level" => "debug",
    "mvt_enabled" => "true",
    "news_apps_hardcoded_response" => "disabled",
    "news_apps_variance_reducer" => "disabled",
    "news_articles_personalisation" => "on",
    "ni_election_failover" => "off",
    "non_webcore_ttl_multiplier" => "default",
    "obit_mode" => "off",
    "personalisation" => "on",
    "webcore_kill_switch" => "inactive",
    "webcore_ttl_multiplier" => "default"
  }

  describe "decode/1 converts valid and ignores invalid dials for" do
    test "dials map" do
      assert Config.decode(@default_dials) == [
               webcore_ttl_multiplier: 1,
               webcore_kill_switch: false,
               personalisation: true,
               obit_mode: "off",
               non_webcore_ttl_multiplier: 1,
               ni_election_failover: "off",
               news_articles_personalisation: true,
               news_apps_variance_reducer: false,
               news_apps_hardcoded_response: false,
               mvt_enabled: true,
               logging_level: :debug,
               football_scores_fixtures: "mozart",
               election_banner_ni_story: "off",
               election_banner_council_story: "off",
               circuit_breaker: false,
               ccp_enabled: true,
               cache_enabled: true,
               bbcx_enabled: true
             ]
    end

    test "bbcx_enabled" do
      assert Config.decode({"bbcx_enabled", "true"}) == {:bbcx_enabled, true}
      assert Config.decode({"bbcx_enabled", "false"}) == {:bbcx_enabled, false}
      assert Config.decode({"bbcx_enabled", "invalid"}) == nil
    end

    test "cache_enabled" do
      assert Config.decode({"cache_enabled", "true"}) == {:cache_enabled, true}
      assert Config.decode({"cache_enabled", "false"}) == {:cache_enabled, false}
      assert Config.decode({"cache_enabled", "invalid"}) == nil
    end

    test "ccp_enabled" do
      assert Config.decode({"ccp_enabled", "true"}) == {:ccp_enabled, true}
      assert Config.decode({"ccp_enabled", "false"}) == {:ccp_enabled, false}
      assert Config.decode({"ccp_enabled", "invalid"}) == nil
    end

    test "circuit_breaker" do
      assert Config.decode({"circuit_breaker", "true"}) == {:circuit_breaker, true}
      assert Config.decode({"circuit_breaker", "false"}) == {:circuit_breaker, false}
      assert Config.decode({"circuit_breaker", "invalid"}) == nil
    end

    test "election_banner_council_story" do
      assert Config.decode({"election_banner_council_story", "on"}) == {:election_banner_council_story, "on"}
      assert Config.decode({"election_banner_council_story", "off"}) == {:election_banner_council_story, "off"}
      assert Config.decode({"election_banner_council_story", "invalid"}) == nil
    end

    test "election_banner_ni_story" do
      assert Config.decode({"election_banner_ni_story", "on"}) == {:election_banner_ni_story, "on"}
      assert Config.decode({"election_banner_ni_story", "off"}) == {:election_banner_ni_story, "off"}
      assert Config.decode({"election_banner_ni_story", "invalid"}) == nil
    end

    test "obit_mode" do
      assert Config.decode({"obit_mode", "on"}) == {:obit_mode, "on"}
      assert Config.decode({"obit_mode", "off"}) == {:obit_mode, "off"}
      assert Config.decode({"obit_mode", "invalid"}) == nil
    end

    test "football_scores_fixtures" do
      assert Config.decode({"football_scores_fixtures", "mozart"}) == {:football_scores_fixtures, "mozart"}
      assert Config.decode({"football_scores_fixtures", "webcore"}) == {:football_scores_fixtures, "webcore"}
      assert Config.decode({"football_scores_fixtures", "invalid"}) == nil
    end

    test "logging_level" do
      for level <- ["debug", "info", "warn", "error"],
          do: assert(Config.decode({"logging_level", level}) == {:logging_level, String.to_atom(level)})

      assert Config.decode({"logging_level", "invalid"}) == nil
    end

    test "news_apps_hardcoded_response" do
      assert Config.decode({"news_apps_hardcoded_response", "enabled"}) == {:news_apps_hardcoded_response, true}
      assert Config.decode({"news_apps_hardcoded_response", "disabled"}) == {:news_apps_hardcoded_response, false}
      assert Config.decode({"news_apps_hardcoded_response", "invalid"}) == nil
    end

    test "news_apps_variance_reducer" do
      assert Config.decode({"news_apps_variance_reducer", "enabled"}) == {:news_apps_variance_reducer, true}
      assert Config.decode({"news_apps_variance_reducer", "disabled"}) == {:news_apps_variance_reducer, false}
      assert Config.decode({"news_apps_variance_reducer", "invalid"}) == nil
    end

    test "personalisation" do
      assert Config.decode({"personalisation", "on"}) == {:personalisation, true}
      assert Config.decode({"personalisation", "off"}) == {:personalisation, false}
      assert Config.decode({"personalisation", "invalid"}) == nil
    end

    test "webcore_kill_switch" do
      assert Config.decode({"webcore_kill_switch", "active"}) == {:webcore_kill_switch, true}
      assert Config.decode({"webcore_kill_switch", "inactive"}) == {:webcore_kill_switch, false}
      assert Config.decode({"webcore_kill_switch", "invalid"}) == nil
    end

    test "non_webcore_ttl_multiplier" do
      assert Config.decode({"non_webcore_ttl_multiplier", "very-short"}) == {:non_webcore_ttl_multiplier, 0.5}
      assert Config.decode({"non_webcore_ttl_multiplier", "short"}) == {:non_webcore_ttl_multiplier, 0.75}
      assert Config.decode({"non_webcore_ttl_multiplier", "default"}) == {:non_webcore_ttl_multiplier, 1}
      assert Config.decode({"non_webcore_ttl_multiplier", "long"}) == {:non_webcore_ttl_multiplier, 2}
      assert Config.decode({"non_webcore_ttl_multiplier", "very-long"}) == {:non_webcore_ttl_multiplier, 4}
      assert Config.decode({"non_webcore_ttl_multiplier", "longest"}) == {:non_webcore_ttl_multiplier, 6}
      assert Config.decode({"non_webcore_ttl_multiplier", "invalid"}) == nil
    end

    test "webcore_ttl_multiplier" do
      assert Config.decode({"webcore_ttl_multiplier", "very-short"}) == {:webcore_ttl_multiplier, 1 / 3}
      assert Config.decode({"webcore_ttl_multiplier", "short"}) == {:webcore_ttl_multiplier, 2 / 3}
      assert Config.decode({"webcore_ttl_multiplier", "default"}) == {:webcore_ttl_multiplier, 1}
      assert Config.decode({"webcore_ttl_multiplier", "long"}) == {:webcore_ttl_multiplier, 6}
      assert Config.decode({"webcore_ttl_multiplier", "very-long"}) == {:webcore_ttl_multiplier, 12}
      assert Config.decode({"webcore_ttl_multiplier", "longest"}) == {:webcore_ttl_multiplier, 24}
      assert Config.decode({"webcore_ttl_multiplier", "invalid"}) == nil
    end
  end

  describe "action/1 runs corresponding action for" do
    test "dials map" do
      assert Config.action(%{@default_dials | "logging_level" => "error"}) == :ok
      assert Application.get_env(:logger, :file)[:level] == :error

      set_default_dials_actions()
    end

    test "logging_level" do
      for level <- ["debug", "info", "warn", "error"] do
        assert Config.action({"logging_level", level}) == :ok
        assert Application.get_env(:logger, :file)[:level] == String.to_atom(level)
      end

      set_default_dials_actions()
    end
  end

  defp set_default_dials_actions() do
    Config.action(@default_dials)
  end
end
