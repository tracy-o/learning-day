defmodule Belfrage.Logger.FormatterTest do
  alias Belfrage.Logger.Formatter
  use ExUnit.Case, async: true

  test "core returns formatted log when metadata does not have :cloudwatch" do
    message = "my log"

    assert message <> "\n" == Formatter.core(:error, message, "", [])
  end

  test "core returns empty string when metadata has :cloudwatch" do
    message = "my log"

    assert "" == Formatter.core(:error, message, "", cloudwatch: true)
  end

  test "cloudwatch returns empty string when metadata does not have :cloudwatch" do
    message = "my log"

    assert "" == Formatter.cloudwatch(:error, message, "", [])
  end

  test "cloudwatch returns formatted log when metadata has :cloudwatch" do
    message = "my log"

    assert message <> "\n" == Formatter.cloudwatch(:error, message, "", cloudwatch: true)
  end
end
