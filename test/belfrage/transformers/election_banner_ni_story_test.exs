defmodule Belfrage.Transformers.ElectionBannerNiStoryTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  import Belfrage.Test.StubHelper

  alias Belfrage.Transformers.ElectionBannerNiStory
  alias Belfrage.Struct

  @struct %Struct{
    request: %Struct.Request{
      raw_headers: %{"header1" => "header1value"}
    }
  }

  describe "when the ElectionBannerNiStory dial is on" do
    test "election-banner-ni-story: 'on' exists in headers" do
      stub_dial(:election_banner_ni_story, "on")

      {:ok, struct} = ElectionBannerNiStory.call([], @struct)
      assert struct.request.raw_headers == %{"header1" => "header1value", "election-banner-ni-story" => "on"}
    end
  end

  describe "when the ElectionBannerNiStory dial is off" do
    test "election-banner-ni-story: 'on' exists in headers" do
      stub_dial(:election_banner_ni_story, "off")

      {:ok, struct} = ElectionBannerNiStory.call([], @struct)
      assert struct.request.raw_headers == %{"header1" => "header1value", "election-banner-ni-story" => "off"}
    end
  end
end
