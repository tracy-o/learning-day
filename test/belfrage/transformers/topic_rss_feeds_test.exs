defmodule Belfrage.Transformers.TopicRssFeedsTest do
  use ExUnit.Case

  alias Belfrage.Transformers.TopicRssFeeds
  alias Belfrage.Struct

  test "point to rss FABL module and adds topicId query param to request" do
    assert {
             :ok,
             %Struct{
               request: %Struct.Request{
                 path: "/fd/rss",
                 path_params: %{
                   "name" => "rss"
                 },
                 query_params: %{
                   "topicId" => "testId"
                 },
                 raw_headers: %{
                   "ctx-unwrapped" => "1"
                 }
               }
             }
           } =
             TopicRssFeeds.call([], %Struct{
               request: %Struct.Request{path_params: %{"id" => "testId"}}
             })
  end
end
