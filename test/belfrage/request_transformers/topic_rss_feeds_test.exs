defmodule Belfrage.RequestTransformers.TopicRssFeedsTest do
  use ExUnit.Case

  alias Belfrage.RequestTransformers.TopicRssFeeds
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
                   "topicId" => "testId",
                   "uri" => "/topics/testId"
                 },
                 raw_headers: %{
                   "ctx-unwrapped" => "1"
                 }
               }
             }
           } =
             TopicRssFeeds.call(%Struct{
               request: %Struct.Request{
                 path: "/topics/testId/rss.xml",
                 path_params: %{"id" => "testId"}
               }
             })
  end
end
