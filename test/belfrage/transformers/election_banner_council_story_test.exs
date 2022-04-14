defmodule Belfrage.Transformers.ElectionBannerCouncilStoryTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  import Belfrage.Test.StubHelper

  alias Belfrage.Transformers.ElectionBannerCouncilStory
  alias Belfrage.Struct

  @struct %Struct{
    request: %Struct.Request{
      raw_headers: %{"header1" => "header1value"}
    }
  }

  describe "when the ElectionBannerCouncilStory dial is on" do
    test "election-banner-council-story: 'on' exists in headers" do
      stub_dial(:election_banner_council_story, "on")

      {:ok, struct} = ElectionBannerCouncilStory.call([], @struct)
      assert struct.request.raw_headers == %{"header1" => "header1value", "election-banner-council-story" => "on"}
    end
  end

  describe "when the ElectionBannerCouncilStory dial is off" do
    test "election-banner-council-story: 'off' exists in headers" do
      stub_dial(:election_banner_council_story, "off")

      {:ok, struct} = ElectionBannerCouncilStory.call([], @struct)
      assert struct.request.raw_headers == %{"header1" => "header1value", "election-banner-council-story" => "off"}
    end
  end
end
