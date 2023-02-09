defmodule Belfrage.RequestTransformers.TopicRssFeedsTest do
  use ExUnit.Case

  alias Belfrage.RequestTransformers.TopicRssFeeds
  alias Belfrage.Envelope

  test "point to rss FABL module and adds topicId and uri query params to request" do
    assert {
             :ok,
             %Envelope{
               request: %Envelope.Request{
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
             TopicRssFeeds.call(%Envelope{
               request: %Envelope.Request{
                 path: "/topics/testId/rss.xml",
                 path_params: %{"id" => "testId"}
               }
             })
  end
end
