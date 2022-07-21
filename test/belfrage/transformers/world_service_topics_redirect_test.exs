defmodule Belfrage.Transformers.WorldServiceTopicsRedirectTest do
  use ExUnit.Case

  alias Belfrage.Transformers.WorldServiceTopicsRedirect
  alias Belfrage.Struct

  test "redirects old to new ws topics page - w/o variant" do
    assert {
             :redirect,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 http_status: 301,
                 body: "Redirecting",
                 headers: %{
                   "location" => "/pidgin/topics/cqywjyzk2vyt?page=5",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, max-age=60"
                 }
               }
             }
           } =
             WorldServiceTopicsRedirect.call([], %Struct{
               request: %Struct.Request{
                 path: "/pidgin/topics/cqywjyzk2vyt/page/5",
                 path_params: %{"page" => "5", "id" => "cqywjyzk2vyt"}
               }
             })
  end

  test "redirects old to new ws topics page - w/ variant" do
    assert {
             :redirect,
             %Belfrage.Struct{
               response: %Belfrage.Struct.Response{
                 http_status: 301,
                 body: "Redirecting",
                 headers: %{
                   "location" => "/serbian/cyr/topics/cqwvxvvw9qrt?page=5",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, max-age=60"
                 }
               }
             }
           } =
             WorldServiceTopicsRedirect.call([], %Struct{
               request: %Struct.Request{
                 path: "/serbian/cyr/topics/cqwvxvvw9qrt/page/5",
                 path_params: %{"page" => "5", "id" => "cqwvxvvw9qrt"}
               }
             })
  end
end