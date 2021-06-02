defmodule Belfrage.Dials.LoggingLevelTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox
  alias Belfrage.Dials.LoggingLevel
  alias Belfrage.Helpers.FileIOMock

  setup do
    FileIOMock
    |> expect(:read, fn _ -> "" end)

    start_supervised!(Belfrage.Dials.Poller)

    :ok
  end

  def log_level() do
    Application.get_env(:logger, :file)[:level]
  end

  describe "on_change/1" do
    test "When the dial is set to debug, so is the logging level" do
      assert LoggingLevel.on_change(:debug) == :ok
      assert log_level() == :debug
    end

    test "When the dial is set to info, so is the logging level" do
      assert LoggingLevel.on_change(:info) == :ok
      assert log_level() == :info
    end

    test "When the dial is set to warn, so is the logging level" do
      assert LoggingLevel.on_change(:warn) == :ok
      assert log_level() == :warn
    end

    test "When the dial is set to error, so is the logging level" do
      assert LoggingLevel.on_change(:error) == :ok
      assert log_level() == :error
    end
  end
end
