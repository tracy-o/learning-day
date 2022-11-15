defmodule Belfrage.RequestTransformers.SportFootballScoresFixturesPointerTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.SportFootballScoresFixturesPointer
  alias Belfrage.Struct

  defp struct do
    %Struct{
      private: %Struct.Private{platform: MozartSport}
    }
  end

  describe "when the Dial is pointing to Mozart (default)" do
    test "platform will stay as Mozart" do
      assert {
               :stop_pipeline,
               %Belfrage.Struct{
                 response: %Belfrage.Struct.Response{
                   http_status: 500
                 }
               }
      } = SportFootballScoresFixturesPointer.call([], struct())
     end
   end
end
