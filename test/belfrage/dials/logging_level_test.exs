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

  describe "on_refresh/1" do
    test "When the dial is is set to default, the Logging level remains unchanged" do
      initial_level = Logger.level()

      assert LoggingLevel.on_refresh(%{"logging_level" => "default"}) == initial_level
    end

    test "When the dial is set to something unexpected, the logging level remains unchanged" do
      initial_level = Logger.level()

      assert LoggingLevel.on_refresh(%{"logging_level" => "something unexpected"}) == initial_level
    end

    test "When the dial is set to debug, so is the logging level" do
      assert LoggingLevel.on_refresh(%{"logging_level" => "debug"}) == :debug
    end

    test "When the dial is set to info, so is the logging level" do
      assert LoggingLevel.on_refresh(%{"logging_level" => "info"}) == :info
    end

    test "When the dial is set to warn, so is the logging level" do
      assert LoggingLevel.on_refresh(%{"logging_level" => "warn"}) == :warn
    end

    test "When the dial is set to error, so is the logging level" do
      assert LoggingLevel.on_refresh(%{"logging_level" => "error"}) == :error
    end
  end
end
