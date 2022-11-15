defmodule Belfrage.RequestTransformers.SportFootballScoresFixturesPointerTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.SportFootballScoresFixturesPointer
  alias Belfrage.Struct

  defp stub_dial_as(platform) do
    stub(Belfrage.Dials.ServerMock, :state, fn :football_scores_fixtures ->
      Belfrage.Dials.FootballScoresFixtures.transform(platform)
    end)
  end

  defp struct do
    %Struct{
      private: %Struct.Private{
        platform: MozartSport
      }
    }
  end

  describe "when the Dial is pointing to Mozart (default)" do
    test "platform will stay as Mozart" do
      stub_dial_as("mozart")

      assert {:ok, %Struct{private: %{platform: MozartSport}}} = SportFootballScoresFixturesPointer.call([], struct())
    end
  end

  describe "when the Dial is pointing to Webcore" do
    test "platform will point to Webcore" do
      stub_dial_as("webcore")

      assert {:ok, %Struct{private: %{platform: Webcore}}} = SportFootballScoresFixturesPointer.call([], struct())
    end
  end

  # assert {:ok, %Belfrage.Struct{private: %{response_pipeline: }}} = SportFootballScoresFixturesPointer.call([], struct())
end
