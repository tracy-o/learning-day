defmodule Belfrage.Transformers.SportRssPlatformTopicIdMappingTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Transformers.SportRssPlatformTopicIdMapping
  alias Belfrage.Struct

  test "when the path matches a key from the mapping object the request is pointed to the rss FABL module, with the correct query parameter" do
    fabl_endpoint = Application.get_env(:belfrage, :fabl_endpoint)

    assert {
             :ok,
             %Struct{
               private: %Struct.Private{
                 platform: Fabl,
                 origin: ^fabl_endpoint
               },
               request: %Struct.Request{
                 path: "/fd/rss",
                 path_params: %{
                   "name" => "rss"
                 },
                 query_params: %{
                   "topicId" => "c22ymglr3x3t"
                 },
                 raw_headers: %{
                   "ctx-unwrapped" => "1"
                 }
               }
             }
           } =
             SportRssPlatformTopicIdMapping.call([], %Struct{
               request: %Struct.Request{path: "/sport/rss.xml"}
             })
  end

  test "when the path does not match a key from the mapping object, the request continues to Karanga" do
    karanga_endpoint = Application.get_env(:belfrage, :karanga_endpoint)

    assert {
             :ok,
             %Struct{
               private: %Struct.Private{
                 platform: Karanga,
                 origin: ^karanga_endpoint
               }
             }
           } =
             SportRssPlatformTopicIdMapping.call([], %Struct{
               private: %Struct.Private{
                 platform: Karanga,
                 origin: karanga_endpoint
               },
               request: %Struct.Request{path: "/sport/football/teams/rss.xml"}
             })
  end
end
