defmodule Belfrage.PreflightTransformers.SportFootballScoresFixturesPointerTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.PreflightTransformers.SportFootballScoresFixturesPointer
  alias Belfrage.Envelope

  defp envelope do
    %Envelope{request: %Envelope.Request{path: "/sport/football/scores-fixtures"}}
  end

  describe "when the Dial is pointing to Mozart (default)" do
    test "platform will stay as Mozart" do
      stub_dials(football_scores_fixtures: "mozart")

      assert {:ok, %Envelope{private: %{platform: "MozartSport"}}} = SportFootballScoresFixturesPointer.call(envelope())
    end
  end

  describe "when the Dial is pointing to Webcore" do
    test "platform will point to Webcore" do
      stub_dials(football_scores_fixtures: "webcore")

      assert {:ok, %Envelope{private: %{platform: "Webcore"}}} = SportFootballScoresFixturesPointer.call(envelope())
    end
  end
end
