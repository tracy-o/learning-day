defmodule Belfrage.Transformers.LocalNewsTopicsRedirectTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.Transformers.LocalNewsTopicsRedirect
  alias Belfrage.Struct

  import Fixtures.Struct

  test "If the location ID is in the mapping, then a redirect will be issued" do
    struct =
      request_struct(:https, "www.bbc.com", "/news/localnews/6296650-somelocation/30", %{}, %{
        "location_id_and_name" => "6296650-somelocation"
      })

    assert {:redirect,
            %Struct{
              response: %Struct.Response{
                http_status: 302,
                headers: %{
                  "location" => "/news/topics/cxrlk4ywplxt",
                  "x-bbc-no-scheme-rewrite" => "1",
                  "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                },
                body: "Redirecting"
              }
            }} = LocalNewsTopicsRedirect.call([], struct)
  end

  test "If the location ID is not in the mapping, a 404 will be issued" do
    struct =
      request_struct(:https, "www.bbc.com", "/news/localnews/12345-somelocation/30", %{}, %{
        "location_id_and_name" => "12345-somelocation"
      })

    assert {:stop_pipeline, %Struct{response: %Struct.Response{http_status: 404}}} =
             LocalNewsTopicsRedirect.call([], struct)
  end

  test "If the path does not start with /news/localnews/, a 404 will be issued" do
    struct =
      request_struct(:https, "www.bbc.com", "/some/path/6296650-somelocation/30", %{}, %{
        "location_id_and_name" => "6296650-somelocation"
      })

    assert {:stop_pipeline, %Struct{response: %Struct.Response{http_status: 404}}} =
             LocalNewsTopicsRedirect.call([], struct)
  end
end
