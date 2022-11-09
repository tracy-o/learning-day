defmodule Belfrage.RequestTransformers.SportTopicRssFeedsMapperTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.SportTopicRssFeedsMapper
  alias Belfrage.Struct

  test "point to rss FABL module and adds topicId and uri query params to request" do
    assert {
             :ok,
             %Struct{
               request: %Struct.Request{
                 path: "/fd/rss",
                 path_params: %{
                   "name" => "rss"
                 },
                 query_params: %{
                   "topicId" => "c22ymglr3x3t",
                   "uri" => "/sport"
                 },
                 raw_headers: %{
                   "ctx-unwrapped" => "1"
                 }
               }
             }
           } =
             SportTopicRssFeedsMapper.call([], %Struct{
               request: %Struct.Request{path: "/sport/rss.xml"}
             })
  end
end
