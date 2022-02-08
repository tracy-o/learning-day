defmodule Belfrage.Dials.LiveServerTest do
  use ExUnit.Case, async: true

  alias Belfrage.Dial
  alias Belfrage.Dials.LiveServer

  defmodule TestDial do
    @behaviour Dial

    def transform(value) do
      case value do
        "true" -> true
        "false" -> false
      end
    end
  end

  # This Dial will keep the updated value in its state so that it could be
  # fetched and verified
  defmodule TestDialWithCallback do
    use Agent

    def start_link(_opts) do
      Agent.start_link(fn -> nil end, name: __MODULE__)
    end

    def value() do
      Agent.get(__MODULE__, & &1)
    end

    @behaviour Dial

    def transform(value), do: value

    def on_change(value) do
      Agent.update(__MODULE__, fn _old_value -> value end)
    end
  end

  setup do
    default_value = "true"
    dial_name = :"a-test-dial"
    start_supervised!({LiveServer, {TestDial, dial_name, default_value}})
    :ok
  end

  test "dial correctly handles changed event in which the dial boolean state is flipped" do
    dial_state = LiveServer.state(:"a-test-dial")
    GenServer.cast(:"a-test-dial", {:dials_changed, %{"a-test-dial" => "#{!dial_state}"}})

    assert LiveServer.state(:"a-test-dial") == !dial_state
  end

  describe "state/0" do
    test "returns transformed initial value after init" do
      assert LiveServer.state(:"a-test-dial") == true
    end
  end

  describe ":dials_changed logic" do
    test "when no changes are submitted" do
      state = {TestDial, "a-test-dial", true}

      assert {:noreply, {TestDial, "a-test-dial", true}} ==
               LiveServer.handle_cast({:dials_changed, %{}}, state)
    end

    test "when a change for a different dial is submitted" do
      state = {TestDial, "a-test-dial", true}

      assert {:noreply, {TestDial, "a-test-dial", true}} ==
               LiveServer.handle_cast({:dials_changed, %{"foo" => "bar"}}, state)
    end

    test "when a valid change for the dial is submitted" do
      state = {TestDial, "a-test-dial", true}

      assert {:noreply, {TestDial, "a-test-dial", false}} ==
               LiveServer.handle_cast({:dials_changed, %{"a-test-dial" => "false"}}, state)
    end

    test "when dial has on_change/1 callback logic, it is called" do
      start_supervised!(TestDialWithCallback)
      refute TestDialWithCallback.value()

      state = {TestDialWithCallback, "a-test-dial", true}

      assert {:noreply, {TestDialWithCallback, "a-test-dial", false}} ==
               LiveServer.handle_cast({:dials_changed, %{"a-test-dial" => false}}, state)

      assert TestDialWithCallback.value() == false
    end
  end
end
