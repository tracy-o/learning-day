defmodule Belfrage.Dials.LoggingLevelTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Dials.LoggingLevel

  setup do
    Belfrage.Dials.Poller.clear()
    :ok
  end

  def log_level() do
    Application.get_env(:logger, :file)[:level]
  end

  describe "on_refresh/1" do
    test "When the dial returns an empty map, the logging level remains unchanged" do
      initial_level = log_level()

      assert LoggingLevel.on_refresh(%{}) == {:error, "Invalid logging level"}
      assert log_level() == initial_level
    end

    test "When the dial is set to something unexpected, the logging level remains unchanged" do
      initial_level = log_level()
      assert LoggingLevel.on_refresh(%{"logging_level" => "something unexpected"}) == {:error, "Invalid logging level"}
      assert log_level() == initial_level
    end

    test "When the dial is set to debug, so is the logging level" do
      assert LoggingLevel.on_refresh(%{"logging_level" => "debug"}) == :ok
      assert log_level() == :debug
    end

    test "When the dial is set to info, so is the logging level" do
      assert LoggingLevel.on_refresh(%{"logging_level" => "info"}) == :ok
      assert log_level() == :info
    end

    test "When the dial is set to warn, so is the logging level" do
      assert LoggingLevel.on_refresh(%{"logging_level" => "warn"}) == :ok
      assert log_level() == :warn
    end

    test "When the dial is set to error, so is the logging level" do
      assert LoggingLevel.on_refresh(%{"logging_level" => "error"}) == :ok
      assert log_level() == :error
    end
  end
end
