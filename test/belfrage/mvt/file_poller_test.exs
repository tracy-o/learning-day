defmodule Belfrage.Mvt.FilePollerTest do
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

    file_poller_pid = start_supervised!({FilePoller, interval: 0, name: :test_mvt_file_poller})
    project_headers = Jason.decode!(@mvt_json_payload)["projects"]

    assert_receive {:trace, ^slots_agent_pid, :receive, {_, {^file_poller_pid, _}, {:update, _}}}, 100
    assert Slots.available() == project_headers
  end

  test "if there is an error fetching the file it will not set the file content in the agent", %{
    slots_agent_pid: slots_agent_pid
  } do
    assert Slots.available() == %{}

    expect(HTTPMock, :execute, fn _, _origin ->
      {:ok, %HTTP.Response{status_code: 500, body: "{foo: \"bar\"}"}}
    end)

    file_poller_pid = start_supervised!({FilePoller, interval: 0, name: :test_mvt_file_poller})

    refute_receive {:trace, ^slots_agent_pid, :receive, {_, {^file_poller_pid, _}, {:update, _}}}, 100
  end

  test "if the file is malformed it will not set the file content in the agent", %{slots_agent_pid: slots_agent_pid} do
    assert Slots.available() == %{}

    expect(HTTPMock, :execute, fn _, _origin ->
      {:ok, %HTTP.Response{status_code: 500, body: "malformed json"}}
    end)

    file_poller_pid = start_supervised!({FilePoller, interval: 0, name: :test_mvt_file_poller})

    refute_receive {:trace, ^slots_agent_pid, :receive, {_, {^file_poller_pid, _}, {:update, _}}}, 100
  end

  def trace_slots_agent(_context) do
    pid = Process.whereis(Belfrage.Mvt.Slots)
    :erlang.trace(pid, true, [:receive])

    {:ok, slots_agent_pid: pid}
  end

  def clear_slots_agent_state(_context) do
    Slots.set(Belfrage.Mvt.Slots, %{})
  end
end
