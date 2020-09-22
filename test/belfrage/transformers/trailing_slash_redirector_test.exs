defmodule Belfrage.Transformers.TrailingSlashRedirectorTest do
  use ExUnit.Case
  alias Belfrage.Struct
  alias Belfrage.Transformers.TrailingSlashRedirector

  @rest []

  defp incoming_request(path, query_params \\ %{}) do
    %Struct{
      request: %Struct.Request{
        method: :get,
        path: path,
        query_params: query_params
      }
    }
  end

  test "no redirect when top level '/' in path " do
    struct = incoming_request("/")

    assert {:ok, struct} == TrailingSlashRedirector.call(@rest, struct)
  end

  test "redirect top level `/` when multiple forward slashes in path " do
    struct = incoming_request("////")

    assert {:redirect, struct} = TrailingSlashRedirector.call(@rest, struct)

    assert %Struct.Response{
             http_status: 301,
             body: "",
             headers: %{
               "cache-control" => "public, max-age=60",
               "location" => "/",
               "x-bbc-no-scheme-rewrite" => "1"
             }
           } = struct.response
  end

  test "no redirect when no trailing slash on path" do
    struct = incoming_request("/a-page")

    assert {:ok, struct} == TrailingSlashRedirector.call(@rest, struct)
  end

  test "no redirect when no trailing slash on path or query string" do
    struct = incoming_request("/a-page", %{"a-query" => nil})

    assert {:ok, struct} == TrailingSlashRedirector.call(@rest, struct)
  end

  test "redirect when root path has trailing slashes" do
    struct = incoming_request("/a-page///")

    assert {:redirect, struct} = TrailingSlashRedirector.call(@rest, struct)

    assert %Struct.Response{
             http_status: 301,
             body: "",
             headers: %{
               "cache-control" => "public, max-age=60",
               "location" => "/a-page",
               "x-bbc-no-scheme-rewrite" => "1"
             }
           } = struct.response
  end

  test "no redirect when no trailing slash on path, but a trailing slash on query string" do
    struct = incoming_request("/a-page", %{"a-query/" => nil})

    assert {:ok, struct} == TrailingSlashRedirector.call(@rest, struct)
  end

  test "redirect when path has trailing slash" do
    struct = incoming_request("/a-page/")

    assert {:redirect, struct} = TrailingSlashRedirector.call(@rest, struct)

    assert %Struct.Response{
             http_status: 301,
             body: "",
             headers: %{
               "cache-control" => "public, max-age=60",
               "location" => "/a-page",
               "x-bbc-no-scheme-rewrite" => "1"
             }
           } = struct.response
  end

  test "redirect when path has trailing slash and query string with no trailing slash" do
    struct = incoming_request("/a-page/", %{"a-query" => nil})

    assert {:redirect, struct} = TrailingSlashRedirector.call(@rest, struct)

    assert %Struct.Response{
             http_status: 301,
             body: "",
             headers: %{
               "cache-control" => "public, max-age=60",
               "location" => "/a-page?a-query=",
               "x-bbc-no-scheme-rewrite" => "1"
             }
           } = struct.response
  end

  test "redirect when path has trailing slash and query string also with a trailing slash" do
    struct = incoming_request("/a-page/", %{"a-query/" => nil})

    assert {:redirect, struct} = TrailingSlashRedirector.call(@rest, struct)

    assert %Struct.Response{
             http_status: 301,
             body: "",
             headers: %{
               "cache-control" => "public, max-age=60",
               "location" => "/a-page?a-query%2F=",
               "x-bbc-no-scheme-rewrite" => "1"
             }
           } = struct.response
  end
end
