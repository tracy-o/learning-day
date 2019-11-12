defmodule Belfrage.Clients.HTTP.ResponseTest do
  use ExUnit.Case

  alias Belfrage.Clients.HTTP

  test "builds an %HTTP.Response{} struct, with headers as a map" do
    assert %HTTP.Response{
             headers: %{"cache-control" => "public, max-age=10"},
             body: "<p>hello</p>",
             status_code: 200
           } ==
             HTTP.Response.new(%{
               body: "<p>hello</p>",
               status_code: 200,
               headers: [{"cache-control", "public, max-age=10"}]
             })
  end

  test "downcases the response header keys for future matching" do
    assert %HTTP.Response{
             headers: %{"cache-control" => "public, max-age=10"},
             body: "<p>hi</p>",
             status_code: 200
           } ==
             HTTP.Response.new(%{
               body: "<p>hi</p>",
               status_code: 200,
               headers: [{"cachE-coNtrol", "public, max-age=10"}]
             })
  end
end
