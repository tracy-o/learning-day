defmodule Support.Smoke.RulesTest do
  use ExUnit.Case
  alias Support.Smoke.Rules

  describe "passed?/1" do
    test "When all checks passed" do
      results = %{
        "PipelineOne" => [:ok, :ok, :ok],
        "PipelineTwo" => [:ok, :ok, :ok]
      }

      assert Rules.passed?(results)
    end

    test "Passes when only one pipeline checks pass" do
      results = %{
        "PipelineOne" => [:ok, :ok, :ok],
        "PipelineTwo" => [:ok, :ok, "Oh no, this important thing broke"],
        "PipelineThree" => [:ok, :ok, "Oh no, this other important thing broke"]
      }

      assert Rules.passed?(results)
    end

    test "Fails when all pipeline checks fail" do
      results = %{
        "PipelineOne" => ["This thing broke", :ok, :ok],
        "PipelineTwo" => [:ok, :ok, "Oh no, this important thing broke"],
        "PipelineThree" => [:ok, :ok, "Oh no, this other important thing broke"]
      }

      refute Rules.passed?(results)
    end
  end

  describe "format_failures/1" do
    test "when there are failures" do
      results = %{
        "PipelineOne" => ["This thing broke", :ok, :ok],
        "PipelineTwo" => [:ok, :ok, "Oh no, this important thing broke"],
        "PipelineThree" => [:ok, :ok, "Oh no, this other important thing broke"]
      }

      failure_msg = Rules.format_failures(results)
      assert failure_msg =~ "Rules for PipelineOne failed"
      assert failure_msg =~ "Rules for PipelineTwo failed"
      assert failure_msg =~ "Rules for PipelineThree failed"
    end

    test "when there are no failures" do
      results = %{
        "PipelineOne" => [:ok, :ok, :ok],
        "PipelineTwo" => [:ok, :ok, :ok]
      }

      failure_msg = Rules.format_failures(results)
      assert failure_msg =~ "PipelineOne passed."
      assert failure_msg =~ "PipelineTwo passed."
    end

    test "when one pipeline fails" do
      results = %{
        "PipelineOne" => [:ok, "oh dear", :ok],
        "PipelineTwo" => [:ok, :ok, :ok]
      }

      failure_msg = Rules.format_failures(results)
      assert failure_msg =~ "Rules for PipelineOne failed"
      assert failure_msg =~ "oh dear"
      assert failure_msg =~ "PipelineTwo passed."
    end
  end
end
