defmodule Belfrage.Dials.LoggingLevelTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Dials.LoggingLevel
  alias Belfrage.Dials

  setup do
    Dials.clear()

    on_exit(fn ->
      Dials.clear()
      :ok
    end)

    :ok
  end

  describe "value/0" do
    test "When the dial is is set to default, the Logging level remains unchanged" do
      inital_level = Logger.level()

      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"logging_level": "default"})} end)

      Dials.refresh_now()
      assert LoggingLevel.value() == inital_level
    end

    test "When the dial is set to something unexpected, the logging level remains unchanged" do
      inital_level = Logger.level()

      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"logging_level": "something unexpected"})} end)

      Dials.refresh_now()
      assert LoggingLevel.value() == inital_level
    end

    test "When the dial is set to debug, so is the logging level" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"logging_level": "debug"})} end)

      Dials.refresh_now()
      assert LoggingLevel.value() == :debug
    end

    test "When the dial is set to info, so is the logging level" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"logging_level": "info"})} end)

      Dials.refresh_now()
      assert LoggingLevel.value() == :info
    end

    test "When the dial is set to warn, so is the logging level" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"logging_level": "warn"})} end)

      Dials.refresh_now()
      assert LoggingLevel.value() == :warn
    end

    test "When the dial is set to error, so is the logging level" do
      Belfrage.Helpers.FileIOMock
      |> expect(:read, fn _ -> {:ok, ~s({"logging_level": "error"})} end)

      Dials.refresh_now()
      assert LoggingLevel.value() == :error
    end
  end
end
