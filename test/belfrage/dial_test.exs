defmodule Belfrage.DialTest do
  use ExUnit.Case, async: false

  alias Belfrage.Dial
  alias Belfrage.Dial.{ClientMock, ClientWithOptionalCallbackMock}

  use Test.Support.Helper, :mox

  setup do
    default_value = "true"
    dial_name = :"a-test-dial"

    {:ok, _pid} = Belfrage.Dial.start_link({ClientMock, dial_name, default_value})

    :ok
  end

  test "dial correctly handles changed event in which the dial boolean state is flipped" do
    ClientMock
    |> expect(:transform, fn
      "false" -> false
      "true" -> true
    end)

    dial_state = Dial.state(:"a-test-dial")
    GenServer.cast(:"a-test-dial", {:dials_changed, %{"a-test-dial" => "#{!dial_state}"}})

    assert Dial.state(:"a-test-dial") == !dial_state
  end

  describe "state/0" do
    test "returns transformed initial value after init" do
      assert Dial.state(:"a-test-dial") == true
    end
  end

  describe ":dials_changed logic" do
    test "when no changes are submitted" do
      state = {ClientMock, "a-test-dial", true}

      assert {:noreply, {ClientMock, "a-test-dial", true}} ==
               Dial.handle_cast({:dials_changed, %{}}, state)
    end

    test "when a change for a different dial is submitted" do
      state = {ClientMock, "a-test-dial", true}

      assert {:noreply, {ClientMock, "a-test-dial", true}} ==
               Dial.handle_cast({:dials_changed, %{"foo" => "bar"}}, state)
    end

    test "when a valid change for the dial is submitted" do
      state = {ClientMock, "a-test-dial", true}

      assert {:noreply, {ClientMock, "a-test-dial", false}} ==
               Dial.handle_cast({:dials_changed, %{"a-test-dial" => "false"}}, state)
    end

    test "when dial has on_change/1 callback logic, it is called" do
      ClientWithOptionalCallbackMock
      |> expect(:on_change, fn false -> :ok end)

      state = {ClientWithOptionalCallbackMock, "a-test-dial", true}

      assert {:noreply, {ClientWithOptionalCallbackMock, "a-test-dial", false}} ==
               Dial.handle_cast({:dials_changed, %{"a-test-dial" => "false"}}, state)
    end
  end
end
