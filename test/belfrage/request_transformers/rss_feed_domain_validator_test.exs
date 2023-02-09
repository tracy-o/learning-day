defmodule Belfrage.RequestTransformers.RssFeedDomainValidatorTest do
  use ExUnit.Case

  alias Belfrage.RequestTransformers.RssFeedDomainValidator
  alias Belfrage.Envelope

  test "requests to the feeds subdomain are allowed" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "feeds.bbci.co.uk",
        path: "/topics/topicId/rss.xml",
        subdomain: "feeds"
      }
    }

    assert {:ok, ^envelope} = RssFeedDomainValidator.call(envelope)
  end

  test "requests to the www subdomain are stopped" do
    envelope = %Envelope{
      request: %Envelope.Request{
        scheme: :https,
        host: "www.bbc.co.uk",
        path: "/topics/topicId/rss.xml",
        subdomain: "www"
      }
    }

    assert {
             :stop,
             %Envelope{
               response: %Envelope.Response{http_status: 404}
             }
           } = RssFeedDomainValidator.call(envelope)
  end
end
