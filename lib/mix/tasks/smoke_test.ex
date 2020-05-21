defmodule Mix.Tasks.SmokeTest do
  use Mix.Task

  @smoke_test_directory "test/smoke/"

  @shortdoc "Smoke tests for Belfrage routes"
  def run(args) do
    Mix.shell().cmd("MIX_ENV=smoke_test mix test #{@smoke_test_directory} " <> Enum.join(args, " "))
  end
end
