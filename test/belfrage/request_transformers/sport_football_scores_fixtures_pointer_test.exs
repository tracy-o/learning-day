defmodule Belfrage.RequestTransformers.SportFootballScoresFixturesPointerTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.SportFootballScoresFixturesPointer
  alias Belfrage.Struct

  defp struct do
    %Struct{
      private: %Struct.Private{
        platform: MozartSport
      }
    }
  end

  describe "when the Dial is pointing to Mozart (default)" do
    test "platform will stay as Mozart" do
      stub_dials(football_scores_fixtures: "mozart")

      assert {:ok, %Struct{private: %{platform: MozartSport}}} = SportFootballScoresFixturesPointer.call([], struct())
    end
  end

  describe "when the Dial is pointing to Webcore" do
    test "platform will point to Webcore" do
      stub_dials(football_scores_fixtures: "webcore")

      assert {:ok, %Struct{private: %{platform: Webcore, origin: "pwa-lambda-function"}}} =
               SportFootballScoresFixturesPointer.call([], struct())
    end
  end
end