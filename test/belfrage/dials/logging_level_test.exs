defmodule Belfrage.Dials.LoggingLevelTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Dials.LoggingLevel
  alias Belfrage.Dials

  setup do
    Dials.clear()
    :ok
  end

  describe "on_refresh/1" do
    test "When the dial is set to something unexpected, the logging level remains unchanged" do
      initial_level = Logger.level()

      assert LoggingLevel.on_refresh(%{"logging_level" => "something unexpected"}) == initial_level
      assert Logger.level() == initial_level
    end

    test "When the dial is set to debug, so is the logging level" do
      assert LoggingLevel.on_refresh(%{"logging_level" => "debug"}) == :debug
      assert Logger.level() == :debug
    end

    test "When the dial is set to info, so is the logging level" do
      assert LoggingLevel.on_refresh(%{"logging_level" => "info"}) == :info
      assert Logger.level() == :info
    end

    test "When the dial is set to warn, so is the logging level" do
      assert LoggingLevel.on_refresh(%{"logging_level" => "warn"}) == :warn
      assert Logger.level() == :warn
    end

    test "When the dial is set to error, so is the logging level" do
      assert LoggingLevel.on_refresh(%{"logging_level" => "error"}) == :error
      assert Logger.level() == :error
    end
  end
end
