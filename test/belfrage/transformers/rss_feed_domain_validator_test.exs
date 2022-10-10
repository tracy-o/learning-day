defmodule Belfrage.Transformers.RssFeedDomainValidatorTest do
  use ExUnit.Case

  alias Belfrage.Transformers.RssFeedDomainValidator
  alias Belfrage.Struct

  test "requests to the feeds subdomain are allowed" do
    struct = %Struct{
      request: %Struct.Request{
        scheme: :https,
        host: "feeds.bbci.co.uk",
        path: "/topics/topicId/rss.xml",
        subdomain: "feeds"
      }
    }

    assert {:ok, ^struct} = RssFeedDomainValidator.call([], struct)
  end

  test "requests to the www subdomain are stopped" do
    struct = %Struct{
      request: %Struct.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/topics/topicId/rss.xml",
        subdomain: "www"
      }
    }

    assert {
             :stop_pipeline,
             %Struct{
               response: %Struct.Response{http_status: 404}
             }
           } = RssFeedDomainValidator.call([], struct)
  end
end
