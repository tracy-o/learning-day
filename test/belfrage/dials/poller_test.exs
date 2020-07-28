defmodule Belfrage.Dials.PollerTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Dials.Poller

  setup do
    Poller.clear()

    on_exit(fn ->
      Poller.clear()
      :ok
    end)

    :ok
  end

  describe "handle_info/2" do
    test "when are no dial changes" do
      old_dials = %{"a-dial" => "yes"}

      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _dials_location -> {:ok, ~s({"a-dial": "yes"})} end)

      assert {:noreply,
              %{
                "a-dial" => "yes"
              }} == Poller.handle_info(:refresh, old_dials)
    end

    test "when there are dial changes" do
      old_dials = %{"a-dial" => "no"}

      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _dials_location -> {:ok, ~s({"a-dial": "yes"})} end)

      assert {:noreply,
              %{
                "a-dial" => "yes"
              }} == Poller.handle_info(:refresh, old_dials)
    end
  end

  describe "&state/0" do
    test "state returns initial dial config" do
      assert Poller.state() == %{}
    end

    test "checks the correct path to the dials config" do
      dials_location = Application.get_env(:belfrage, :dials_location)

      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn ^dials_location -> {:ok, ~s({})} end)

      Poller.refresh_now()
      Poller.state()
    end

    test "init/1 sets initial state of dials to an empty map" do
      options = []
      assert {:ok, %{}} = Poller.init(options)
    end

    test "Changing the file and refreshing gives the new dials value" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"some-dial-key": "ok"})} end)

      Poller.refresh_now()
      assert Poller.state() == %{"some-dial-key" => "ok"}
    end

    test "Writing unparsable JSON to the file returns the initial dials values" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({}}}}\\inva\"id: \nJSON!!</what?>})} end)

      Poller.refresh_now()
      assert Poller.state() == %{}
    end

    test "A missing file returns the initial dials values" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:error, :enoent} end)

      Poller.refresh_now()
      assert Poller.state() == %{}
    end
  end
end
