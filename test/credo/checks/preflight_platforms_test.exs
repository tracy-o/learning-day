defmodule Credo.Checks.PreflightPlatformsTest do
  use Credo.Test.Case
  alias Credo.Checks.PreflightPlatforms

  describe "platform explicit Envelope.add/3" do
    test "does not raise an issue if the platform is valid" do
      """
      defmodule TestModule do
        use Belfrage.Behaviours.Transformer

        @impl Transformer
        def call(envelope = %Envelope{request: request}) do
          {:ok, Envelope.add(envelope, :private, %{platform: "Webcore"})}
        end
      end
      """
      |> to_source_file()
      |> run_check(PreflightPlatforms)
      |> refute_issues()
    end

    test "reports a violation if an invalid platform is detected" do
      """
      defmodule TestModule do
        use Belfrage.Behaviours.Transformer

        @impl Transformer
        def call(envelope = %Envelope{request: request}) do
          if String.ends_with?(request.host, "bbc.com") do
            {:ok, Envelope.add(envelope, :private, %{platform: "BBCX"})}
          else
            {:ok, Envelope.add(envelope, :private, %{platform: "InvalidPlatform"})}
          end
        end
      end
      """
      |> to_source_file()
      |> run_check(PreflightPlatforms)
      |> assert_issue()
    end
  end

  describe "platform implicit in Envelope.add/3" do
    test "does not raise an issue if the platform is valid" do
      """
      defmodule TestModule do
        use Belfrage.Behaviours.Transformer

        @impl Transformer
        def call(envelope = %Envelope{request: request}) do
          {:ok, Envelope.add(envelope, :private, %{platform: select_platform(envelope)})}
        end

        defp select_platform(envelope) do
          if some_value = true, do: "Webcore", else: "DotComHomepage"
        end
      end
      """
      |> to_source_file()
      |> run_check(PreflightPlatforms)
      |> refute_issues()
    end

    test "reports a violation if an invalid platform is detected" do
      """
      defmodule TestModule do
        use Belfrage.Behaviours.Transformer

        @impl Transformer
        def call(envelope = %Envelope{request: request}) do
          {:ok, Envelope.add(envelope, :private, %{platform: select_platform(envelope)})}
        end

        defp select_platform(envelope) do
          if some_value = true do
            "InvalidPlatform"
          else
            "DotComHomepage"
          end
        end
      end
      """
      |> to_source_file()
      |> run_check(PreflightPlatforms)
      |> assert_issue()
    end
  end
end
