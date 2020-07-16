defmodule Belfrage.DialTest do
  use ExUnit.Case, async: true

  alias Belfrage.Dial
  alias Belfrage.Dials.Poller
  alias Belfrage.Dials.GenericDial

  @codec Application.get_env(:belfrage, :json_codec)

  setup do
    default_value = "true"
    dial_name = "a-generic-dial"
    {:ok, _pid} = Belfrage.Dial.start_link({GenericDial, dial_name, default_value})

    :ok
  end

  test "dial correctly handles changed event in which the dial boolean state is flipped" do
    dial_state = Dial.state(:"a-generic-dial")
    GenServer.cast(:"a-generic-dial", {:dials_changed, %{"a-generic-dial" => "#{!dial_state}"}})

    assert Dial.state(:"a-generic-dial") == !dial_state
  end

  describe "state/0" do
    test "returns transformed initial value after init" do
      assert Dial.state(:"a-generic-dial") == true
    end
  end

  describe ":dials_changed logic" do
    test "when no changes are submitted" do
      state = {GenericDial, "a-generic-dial", true}

      assert {:noreply, {Belfrage.Dials.GenericDial, "a-generic-dial", true}} ==
               Dial.handle_cast({:dials_changed, %{}}, state)
    end

    test "when a change for a different dial is submitted" do
      state = {GenericDial, "a-generic-dial", true}

      assert {:noreply, {Belfrage.Dials.GenericDial, "a-generic-dial", true}} ==
               Dial.handle_cast({:dials_changed, %{"foo" => "bar"}}, state)
    end

    test "when a valid change for the dial is submitted" do
      state = {GenericDial, "a-generic-dial", true}

      assert {:noreply, {Belfrage.Dials.GenericDial, "a-generic-dial", false}} ==
               Dial.handle_cast({:dials_changed, %{"a-generic-dial" => "false"}}, state)
    end
  end
end
