defmodule Belfrage.Dials.StateTest do
  use ExUnit.Case, async: true

  import Test.Support.Helper, only: [wait_for: 1]
  import Mock

  alias Belfrage.Dials.{State, Config}

  @default_dials_map %{
    bbcx_enabled: true,
    cache_enabled: true,
    ccp_enabled: true,
    circuit_breaker: false,
    election_banner_council_story: "off",
    election_banner_ni_story: "off",
    football_scores_fixtures: "mozart",
    logging_level: :debug,
    mvt_enabled: true,
    news_apps_hardcoded_response: false,
    news_apps_variance_reducer: false,
    news_articles_personalisation: true,
    ni_election_failover: "off",
    non_webcore_ttl_multiplier: 1,
    obit_mode: "off",
    personalisation: true,
    webcore_kill_switch: false,
    webcore_ttl_multiplier: 1
  }

  test "create a dial state table with expected contents" do
    assert Enum.all?(ets_table_contents(), fn {dial, value} ->
             is_atom(dial) and is_valid_dial_value?(value)
           end)
  end

  test "retrieve expected value if dial is in ets table" do
    {dial_name, value} = Enum.random(ets_table_contents())
    assert State.get_dial(dial_name) == value
  end

  test "set default dial values on startup" do
    assert State.list_dials() == @default_dials_map
    assert State.get_dial(:ccp_enabled) == true
  end

  test "poll and updates only changed dials values" do
    assert State.list_dials() == @default_dials_map
    assert State.get_dial(:logging_level) == :debug
    assert State.get_dial(:ccp_enabled) == true

    overwrite_dials_config(~s({"logging_level": "error"}))
    wait_for(fn -> State.get_dial(:logging_level) == :error end)

    assert State.list_dials() == %{@default_dials_map | logging_level: :error}
    assert State.get_dial(:ccp_enabled) == true

    overwrite_dials_config(~s({"logging_level": "debug"}))
    wait_for(fn -> State.get_dial(:logging_level) == :debug end)
  end

  test_with_mock(
    "execute dial action if it's set for the corresponding dial",
    Config,
    [:passthrough],
    action: fn _dials -> :ok end
  ) do
    overwrite_dials_config(~s({"logging_level": "error"}))
    wait_for(fn -> State.get_dial(:logging_level) == :error end)
    assert_called(Config.action(%{"logging_level" => "error"}))

    overwrite_dials_config(~s({"logging_level": "debug"}))
    wait_for(fn -> State.get_dial(:logging_level) == :debug end)
    assert_called(Config.action(%{"logging_level" => "error"}))
  end

  test "do not update invalid dials" do
    assert State.get_dial(:ccp_enabled) == true

    overwrite_dials_config(~s({"logging_level": "error", "ccp_enabled": "invalid"}))
    wait_for(fn -> State.get_dial(:logging_level) == :error end)

    assert State.get_dial(:ccp_enabled) == true

    overwrite_dials_config(~s({"logging_level": "debug"}))
    wait_for(fn -> State.get_dial(:logging_level) == :debug end)
  end

  test "do not update existing dials if dials file is invalid json" do
    assert State.list_dials() == @default_dials_map

    overwrite_dials_config(~s(not a json file))
    sleep_till_poll()

    assert State.list_dials() == @default_dials_map
  end

  test "do not update existing dials if dials file is not found" do
    assert State.list_dials() == @default_dials_map

    set_dials_file_path("non_existing_dials_file.json")
    sleep_till_poll()

    assert State.list_dials() == @default_dials_map
  end

  defp overwrite_dials_config(contents) do
    restore_dials_config_on_exit()
    new_file_path = System.tmp_dir!() |> Path.join("dials.json")
    File.write!(new_file_path, contents)
    set_dials_file_path(new_file_path)
  end

  defp restore_dials_config_on_exit() do
    original_file_path = get_dials_file_path()
    on_exit(fn -> set_dials_file_path(original_file_path) end)
  end

  defp get_dials_file_path() do
    Application.get_env(:belfrage, :dials_location)
  end

  defp set_dials_file_path(file_path) do
    Application.put_env(:belfrage, :dials_location, file_path)
  end

  defp sleep_till_poll() do
    poll_interval = Application.get_env(:belfrage, :poller_intervals)[:dials]
    :timer.sleep(round(poll_interval + poll_interval * 0.1))
  end

  defp ets_table_contents() do
    :ets.tab2list(:dial_state_table)
  end

  defp is_valid_dial_value?(val) when is_atom(val) or is_binary(val) or is_number(val), do: true
  defp is_valid_dial_value?(_other), do: false
end
