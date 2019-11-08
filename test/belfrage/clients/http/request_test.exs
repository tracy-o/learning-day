defmodule Belfrage.Clients.HTTP.RequestTest do
  use ExUnit.Case

  alias Belfrage.Clients.HTTP

  test "builds an HTTP.Request" do
    assert %HTTP.Request{
             headers: %{"accept-encoding" => "application/json"},
             method: :get,
             timeout: 300,
             url: "/a-page"
           } ==
             HTTP.Request.new(%{
               url: "/a-page",
               method: :get,
               headers: [{"accept-encoding", "application/json"}],
               payload: nil,
               timeout: 300
             })
  end

  test "downcases the request header keys" do
    assert %HTTP.Request{
             headers: %{"accept-encoding" => "applicAtion/jsOn"}
           } =
             HTTP.Request.new(%{
               url: "/a-page",
               method: :get,
               headers: [{"AccEpt-encOdiNg", "applicAtion/jsOn"}],
               payload: nil,
               timeout: 300
             })
  end
end
