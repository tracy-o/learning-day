defmodule Belfrage.Logger.FormatterTest do
  alias Belfrage.Logger.Formatter
  use ExUnit.Case, async: true

  describe "format/4" do
    test "returns formatted log" do
      message = "my log"

      assert [log, "\n"] = Formatter.format(:error, message, "", [])
      assert log =~ ~s("message":"my log","level":"error")
    end

    test "handles metadata with an :envelope" do
      message = "my log"

      assert [log, "\n"] =
               Formatter.format(:error, message, {{2023, 2, 13}, {00, 00, 00, 000}},
                 erl_level: :error,
                 application: :belfrage,
                 domain: [:elixir],
                 envelope: %Belfrage.Envelope{
                   request: %Belfrage.Envelope.Request{path: "/content/cps/learning_english/"}
                 }
               )

      assert log =~ ~s("message":"my log","level":"error")
    end
  end

  describe "cloudwatch/4" do
    test "returns empty string when metadata does not have :cloudwatch" do
      message = "my log"

      assert "" == Formatter.cloudwatch(:error, message, "", [])
    end

    test "returns formatted log when metadata has :cloudwatch" do
      message = "my log"

      assert [log, "\n"] = Formatter.cloudwatch(:error, message, "", cloudwatch: true)
      assert log =~ ~s("message":"my log","level":"error")
    end
  end

  describe "app/4" do
    test "returns formatted log when metadata does not have :cloudwatch" do
      message = "my log"

      assert [log, "\n"] = Formatter.app(:error, message, "", [])
      assert log =~ ~s("message":"my log","level":"error")
    end

    test "returns empty string when metadata has :cloudwatch" do
      message = "my log"

      assert "" == Formatter.app(:error, message, "", cloudwatch: true)
    end
  end
end
