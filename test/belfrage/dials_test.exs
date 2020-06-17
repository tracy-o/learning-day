defmodule Belfrage.DialsTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Dials

  setup do
    Dials.clear()

    on_exit(fn ->
      Dials.clear()
      :ok
    end)

    :ok
  end

  describe "&state/0" do
    test "state returns initial dial config" do
      assert Dials.state() == %{}
    end

    test "checks the correct path to the dials config" do
      dials_location = Application.get_env(:belfrage, :dials_location)

      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn ^dials_location -> {:ok, ~s({})} end)

      Dials.refresh_now()
      Dials.state()
    end

    test "init/1 sets initial state of dials to an empty map" do
      options = []
      assert {:ok, %{}} == Dials.init(options)
    end

    test "Changing the file and refreshing gives the new dials value" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"some-dial-key": "ok"})} end)

      Dials.refresh_now()
      assert Dials.state() == %{"some-dial-key" => "ok"}
    end

    test "Writing unparsable JSON to the file returns the initial dials values" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({}}}}\\inva\"id: \nJSON!!</what?>})} end)

      Dials.refresh_now()
      assert Dials.state() == %{}
    end

    test "A missing file returns the initial dials values" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:error, :enoent} end)

      Dials.refresh_now()
      assert Dials.state() == %{}
    end
  end

  describe "logging_level/0" do
    test "When the dial is is set to default, the Logging level remains unchanged" do
      inital_level = Logger.level()

      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"logging_level": "default"})} end)

      Dials.refresh_now()
      assert Dials.logging_level() == inital_level
    end

    test "When the dial is set to something unexpected, the logging level remains unchanged" do
      inital_level = Logger.level()

      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"logging_level": "something unexpected"})} end)

      Dials.refresh_now()
      assert Dials.logging_level() == inital_level
    end

    test "When the dial is set to debug, so is the logging level" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"logging_level": "debug"})} end)

      Dials.refresh_now()
      assert Dials.logging_level() == :debug
    end

    test "When the dial is set to info, so is the logging level" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"logging_level": "info"})} end)

      Dials.refresh_now()
      assert Dials.logging_level() == :info
    end

    test "When the dial is set to warn, so is the logging level" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"logging_level": "warn"})} end)

      Dials.refresh_now()
      assert Dials.logging_level() == :warn
    end

    test "When the dial is set to error, so is the logging level" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"logging_level": "error"})} end)

      Dials.refresh_now()
      assert Dials.logging_level() == :error
    end
  end
end
