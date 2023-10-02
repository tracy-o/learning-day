defmodule Belfrage.RequestTransformers.WorldServiceTopicRssFeedsMapperTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.WorldServiceTopicRssFeedsMapper
  alias Belfrage.Envelope

  describe "World Service Topic RSS Feeds Mapper" do
    test "point to RSS Fabl module and add topicId and uri query params to request for kyrgyz" do
      assert {
               :ok,
               %Envelope{
                 request: %Envelope.Request{
                   path: "/fd/rss",
                   path_params: %{
                     "name" => "rss"
                   },
                   query_params: %{
                     "topicId" => "crg7kj2e52nt",
                     "uri" => "/kyrgyz"
                   },
                   raw_headers: %{
                     "ctx-unwrapped" => "1"
                   }
                 }
               }
             } =
               WorldServiceTopicRssFeedsMapper.call(%Envelope{
                 request: %Envelope.Request{path: "/kyrgyz/rss.xml"}
               })
    end

    migrated_rss_services = [
      "afaanoromoo",
      "amharic",
      "azeri",
      "bengali",
      "burmese",
      "gahuza",
      "gujarati",
      "igbo",
      "indonesia",
      "kyrgyz",
      "marathi",
      "nepali",
      "pidgin",
      "punjabi",
      "sinhala",
      "somali",
      "tamil",
      "telugu",
      "thai",
      "tigrinya",
      "urdu",
      "vietnamese",
      "yoruba"
    ]

    for service <- migrated_rss_services do
      @service service
      test "/#{@service}/rss.xml should point to RSS Fabl module and set uri query param " do
        assert {
                 :ok,
                 %Envelope{
                   request: %Envelope.Request{
                     path: "/fd/rss",
                     path_params: %{
                       "name" => "rss"
                     },
                     query_params: %{
                       "uri" => "/#{@service}"
                     },
                     raw_headers: %{
                       "ctx-unwrapped" => "1"
                     }
                   }
                 }
               } =
                 WorldServiceTopicRssFeedsMapper.call(%Envelope{
                   request: %Envelope.Request{path: "/#{@service}/rss.xml"}
                 })
      end
    end

    legacy_rss_services = [
      "afrique",
      "arabic",
      "hausa",
      "hindi",
      "japanese",
      "korean",
      "mundo",
      "pashto",
      "persian",
      "portuguese",
      "russian",
      "serbian/cyr",
      "serbian/lat",
      "swahili",
      "turkce",
      "ukchina/simp",
      "ukchina/trad",
      "ukrainian",
      "uzbek",
      "zhongwen/simp",
      "zhongwen/trad"
    ]

    for service <- legacy_rss_services do
      @service service
      test "for /#{@service}/rss.xml should not transform the RSS request" do
        assert {:ok,
                %Envelope{
                  request: %Envelope.Request{
                    path: "/#{@service}/rss.xml",
                    path_params: %{},
                    query_params: %{},
                    raw_headers: %{}
                  }
                }} =
                 WorldServiceTopicRssFeedsMapper.call(%Envelope{
                   request: %Envelope.Request{path: "/#{@service}/rss.xml"}
                 })
      end
    end
  end
end
