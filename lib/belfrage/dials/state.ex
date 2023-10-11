defmodule Belfrage.Dials.State do
  use GenServer
  require Logger

  alias Belfrage.Dials.Config

  @dials_state_table :dial_state_table
  @default_poll_interval_ms 5_000

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

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @spec get_dial(atom()) :: term()
  def get_dial(dial_name) do
    case :ets.lookup(@dials_state_table, dial_name) do
      [{_id, value}] -> value
      [] -> nil
    end
  end

  @spec list_dials() :: map()
  def list_dials() do
    Map.new(:ets.tab2list(@dials_state_table))
  end

  # GenServer Callbacks
  @impl GenServer
  def init(_) do
    bootstrap_dials_state_table()
    set_dials(@default_dials)
    start_poll_timer()
    {:ok, %{}}
  end

  @impl GenServer
  def handle_info(:poll, state) do
    start_poll_timer()
    get_set_dials()
    {:noreply, state}
  end

  defp get_set_dials() do
    with {:ok, path} <- File.read(Application.get_env(:belfrage, :dials_location)),
         {:ok, decoded} <- Json.decode(path) do
      set_dials(decoded)
    else
      {:error, :enoent} -> log_read_dial_error(:file_not_found)
      {:error, reason} -> log_read_dial_error(reason)
    end
  end

  defp set_dials(dials) do
    true = :ets.insert(@dials_state_table, Config.decode(dials))
    Config.action(dials)
  end

  defp bootstrap_dials_state_table() do
    :ets.new(@dials_state_table, [:set, :protected, :named_table, read_concurrency: true])
  end

  defp start_poll_timer() do
    poll_interval =
      case Application.get_env(:belfrage, :poller_intervals)[:dials] do
        nil -> @default_poll_interval_ms
        interval -> interval
      end

    Process.send_after(self(), :poll, poll_interval)
  end

  defp log_read_dial_error(reason) do
    Logger.log(:error, "Unable to read dials, reason: #{inspect(reason)}")
  end
end
