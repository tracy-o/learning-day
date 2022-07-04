defmodule Belfrage.Mvt.FilePollerTest do
  import ExUnit.CaptureLog
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Mvt.{FilePoller, Slots}
  alias Belfrage.Clients.{HTTP, HTTPMock}

  @mvt_json_payload File.read!("test/support/fixtures/mvt_slot_headers.json")

  setup [:clear_slots_agent_state, :trace_slots_agent]

  test "fetches and updates Mvt Slots from S3", %{slots_agent_pid: slots_agent_pid} do
    assert Slots.available() == %{}

    expect(HTTPMock, :execute, fn _, _origin ->
      {:ok, %HTTP.Response{status_code: 200, body: @mvt_json_payload}}
    end)

    file_poller_pid = start_supervised!({FilePoller, interval: 200, name: :test_mvt_file_poller})

    assert_receive {:trace, ^slots_agent_pid, :receive, {_, {^file_poller_pid, _}, {:update, _}}}, 100

    assert Slots.available() == %{
             "1" => %{
               "bbc-mvt-1" => "test_feature_1_test",
               "bbc-mvt-2" => "test_experiment_1",
               "bbc-mvt-3" => "test_experiment_2"
             },
             "2" => %{
               "bbc-mvt-1" => "test_feature_1_test",
               "bbc-mvt-2" => "test_experiment_1",
               "bbc-mvt-3" => "test_experiment_2"
             }
           }
  end

  test "if there is an error fetching the file it will not set the file content in the agent", %{
    slots_agent_pid: slots_agent_pid
  } do
    assert Slots.available() == %{}

    expect(HTTPMock, :execute, fn _, _origin ->
      {:ok, %HTTP.Response{status_code: 500, body: "{foo: \"bar\"}"}}
    end)

    file_poller_pid = start_supervised!({FilePoller, interval: 200, name: :test_mvt_file_poller})

    refute_receive {:trace, ^slots_agent_pid, :receive, {_, {^file_poller_pid, _}, {:update, _}}}, 100
    assert Process.alive?(file_poller_pid)
  end

  test "if the file is malformed it will not set the file content in the agent", %{slots_agent_pid: slots_agent_pid} do
    assert Slots.available() == %{}

    expect(HTTPMock, :execute, fn _, _origin ->
      {:ok, %HTTP.Response{status_code: 500, body: "malformed json"}}
    end)

    file_poller_pid = start_supervised!({FilePoller, interval: 200, name: :test_mvt_file_poller})

    refute_receive {:trace, ^slots_agent_pid, :receive, {_, {^file_poller_pid, _}, {:update, _}}}, 100
    assert Process.alive?(file_poller_pid)
  end

  test "if the file has valid JSON but does not have a \"projects\" key, it will not send a message to the Slots Agent",
       %{slots_agent_pid: slots_agent_pid} do
    assert Slots.available() == %{}

    expect(HTTPMock, :execute, fn _, _origin ->
      {:ok, %HTTP.Response{status_code: 200, body: "{\"foo\": \"bar\"}"}}
    end)

    file_poller_pid = start_supervised!({FilePoller, interval: 200, name: :test_mvt_file_poller})

    refute_receive {:trace, ^slots_agent_pid, :receive, {_, {^file_poller_pid, _}, {:update, _}}}, 100
    assert Process.alive?(file_poller_pid)
  end

  test "if the file has valid JSON and \"projects\" key, but the value is not a map, it will not send a message to the Slots Agent",
       %{slots_agent_pid: slots_agent_pid} do
    assert Slots.available() == %{}

    expect(HTTPMock, :execute, fn _, _origin ->
      {:ok,
       %HTTP.Response{
         status_code: 200,
         body: "{\"projects\": [\"something\"]"
       }}
    end)

    file_poller_pid = start_supervised!({FilePoller, interval: 200, name: :test_mvt_file_poller})

    refute_receive {:trace, ^slots_agent_pid, :receive, {_, {^file_poller_pid, _}, {:update, _}}}, 100
    assert Process.alive?(file_poller_pid)
  end

  test "if the file has valid JSON and \"projects\" key, but the value is an empty map, it will not send a message to the Slots Agent",
       %{slots_agent_pid: slots_agent_pid} do
    assert Slots.available() == %{}

    expect(HTTPMock, :execute, fn _, _origin ->
      {:ok,
       %HTTP.Response{
         status_code: 200,
         body: "{\"projects\": %{}"
       }}
    end)

    file_poller_pid = start_supervised!({FilePoller, interval: 200, name: :test_mvt_file_poller})

    refute_receive {:trace, ^slots_agent_pid, :receive, {_, {^file_poller_pid, _}, {:update, _}}}, 100
    assert Process.alive?(file_poller_pid)
  end

  test "if the file has valid JSON and \"projects\" key, but contains an invalid slot format, it will not send a message to the Slots Agent",
       %{slots_agent_pid: slots_agent_pid} do
    assert Slots.available() == %{}

    expect(HTTPMock, :execute, fn _, _origin ->
      {:ok,
       %HTTP.Response{
         status_code: 200,
         body: "{\"projects\": {\"1\": [{\"some_key\": \"test_experiment_1\",\"header\": \"bbc-mvt-2\"}]}}"
       }}
    end)

    file_poller_pid = start_supervised!({FilePoller, interval: 200, name: :test_mvt_file_poller})

    refute_receive {:trace, ^slots_agent_pid, :receive, {_, {^file_poller_pid, _}, {:update, _}}}, 100
    assert Process.alive?(file_poller_pid)
  end

  describe "if the file has valid JSON and \"projects\" key, but a project contains an invalid slot format, the expected log is output" do
    test "when the \"key\" key is not present" do
      assert Slots.available() == %{}

      expect(HTTPMock, :execute, fn _, _origin ->
        {:ok,
         %HTTP.Response{
           status_code: 200,
           body: "{\"projects\": {\"1\": [{\"header\": \"bbc-mvt-2\", \"validFrom\": \"2020-01-01T00:00:00.000Z\"}]}}"
         }}
      end)

      log =
        capture_log(fn ->
          start_supervised!({FilePoller, interval: 200, name: :test_mvt_file_poller})
          Process.sleep(100)
        end)

      assert log =~
               "\"msg\":\"Error processing MVT slot - the expected format: %{\\\"header\\\" => key, \\\"key\\\" => value, \\\"validFrom\\\" => string} does not match the actual format"
    end

    test "when the \"validFrom\" key is not present" do
      assert Slots.available() == %{}

      expect(HTTPMock, :execute, fn _, _origin ->
        {:ok,
         %HTTP.Response{
           status_code: 200,
           body: "{\"projects\": {\"1\": [{\"header\": \"bbc-mvt-2\", \"key\": \"some_value\"}]}}"
         }}
      end)

      log =
        capture_log(fn ->
          start_supervised!({FilePoller, interval: 200, name: :test_mvt_file_poller})
          Process.sleep(100)
        end)

      assert log =~
               "\"msg\":\"Error processing MVT slot - the expected format: %{\\\"header\\\" => key, \\\"key\\\" => value, \\\"validFrom\\\" => string} does not match the actual format"
    end

    test "when neither the \"validFrom\" or \"key\" keys are present" do
      assert Slots.available() == %{}

      expect(HTTPMock, :execute, fn _, _origin ->
        {:ok,
         %HTTP.Response{
           status_code: 200,
           body: "{\"projects\": {\"1\": [{\"some_key\": \"some_value\"}]}}"
         }}
      end)

      log =
        capture_log(fn ->
          start_supervised!({FilePoller, interval: 200, name: :test_mvt_file_poller})
          Process.sleep(100)
        end)

      assert log =~
               "\"msg\":\"Error processing MVT slot - the expected format: %{\\\"header\\\" => key, \\\"key\\\" => value, \\\"validFrom\\\" => string} does not match the actual format"
    end
  end

  test "if the file has valid JSON and \"projects\" key, but a slot has a validFrom datetime in the future it is removed",
       %{slots_agent_pid: slots_agent_pid} do
    expect(HTTPMock, :execute, fn _, _origin ->
      {:ok,
       %HTTP.Response{
         status_code: 200,
         body:
           "{\"projects\": {\"1\": [{\"key\": \"test_experiment_1\",\"header\": \"bbc-mvt-1\", \"validFrom\":\"#{
             future_iso8601(5)
           }\"}, {\"key\": \"test_experiment_2\",\"header\": \"bbc-mvt-2\", \"validFrom\":\"#{past_iso8601(5)}\"}]}}"
       }}
    end)

    file_poller_pid = start_supervised!({FilePoller, interval: 200, name: :test_mvt_file_poller})

    assert_receive {:trace, ^slots_agent_pid, :receive, {_, {^file_poller_pid, _}, {:update, _}}}, 100

    assert Slots.available() == %{
             "1" => %{
               "bbc-mvt-2" => "test_experiment_2"
             }
           }
  end

  test "if the file has valid JSON and \"projects\" key, but a slot has a null validFrom datetime it is removed",
       %{slots_agent_pid: slots_agent_pid} do
    expect(HTTPMock, :execute, fn _, _origin ->
      {:ok,
       %HTTP.Response{
         status_code: 200,
         body:
           "{\"projects\": {\"1\": [{\"key\": \"test_experiment_1\",\"header\": \"bbc-mvt-1\", \"validFrom\":\"null\"}, {\"key\": \"test_experiment_2\",\"header\": \"bbc-mvt-2\", \"validFrom\":\"#{
             past_iso8601(5)
           }\"}]}}"
       }}
    end)

    file_poller_pid = start_supervised!({FilePoller, interval: 200, name: :test_mvt_file_poller})

    assert_receive {:trace, ^slots_agent_pid, :receive, {_, {^file_poller_pid, _}, {:update, _}}}, 100

    assert Slots.available() == %{
             "1" => %{
               "bbc-mvt-2" => "test_experiment_2"
             }
           }
  end

  test "if the file has valid JSON and \"projects\" key, but a slot has an empty-string validFrom datetime it is removed",
       %{slots_agent_pid: slots_agent_pid} do
    expect(HTTPMock, :execute, fn _, _origin ->
      {:ok,
       %HTTP.Response{
         status_code: 200,
         body:
           "{\"projects\": {\"1\": [{\"key\": \"test_experiment_1\",\"header\": \"bbc-mvt-1\", \"validFrom\":\"\"}, {\"key\": \"test_experiment_2\",\"header\": \"bbc-mvt-2\", \"validFrom\":\"#{
             past_iso8601(5)
           }\"}]}}"
       }}
    end)

    file_poller_pid = start_supervised!({FilePoller, interval: 200, name: :test_mvt_file_poller})

    assert_receive {:trace, ^slots_agent_pid, :receive, {_, {^file_poller_pid, _}, {:update, _}}}, 100

    assert Slots.available() == %{
             "1" => %{
               "bbc-mvt-2" => "test_experiment_2"
             }
           }
  end

  def trace_slots_agent(_context) do
    pid = Process.whereis(Belfrage.Mvt.Slots)
    :erlang.trace(pid, true, [:receive])

    {:ok, slots_agent_pid: pid}
  end

  def clear_slots_agent_state(_context) do
    Slots.set(Belfrage.Mvt.Slots, %{})
  end

  defp future_iso8601(n) do
    DateTime.utc_now()
    |> DateTime.add(n, :second, Calendar.UTCOnlyTimeZoneDatabase)
    |> DateTime.to_iso8601()
  end

  defp past_iso8601(n) do
    DateTime.utc_now()
    |> DateTime.add(-n, :second, Calendar.UTCOnlyTimeZoneDatabase)
    |> DateTime.to_iso8601()
  end
end
