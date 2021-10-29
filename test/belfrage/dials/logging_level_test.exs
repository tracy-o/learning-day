defmodule Belfrage.Dials.LoggingLevelTest do
  # Can't be async because it changes the logger config which can affect other
  # tests
  use ExUnit.Case
  alias Belfrage.Dials.LoggingLevel

  setup_all do
    Logger.add_backend({LoggerFileBackend, :file}, Application.get_env(:logger, :file))

    on_exit(fn ->
      Logger.remove_backend({LoggerFileBackend, :file})
    end)
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
