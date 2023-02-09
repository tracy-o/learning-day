defmodule Belfrage.RequestTransformers.WorldServiceTopicsRedirectTest do
  use ExUnit.Case

  alias Belfrage.RequestTransformers.WorldServiceTopicsRedirect
  alias Belfrage.Envelope

  test "redirects old to base of new ws topics page - w/o variant" do
    assert {
             :stop,
             %Belfrage.Envelope{
               response: %Belfrage.Envelope.Response{
                 http_status: 302,
                 body: "Redirecting",
                 headers: %{
                   "location" => "/pidgin/topics/cqywjyzk2vyt",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, max-age=60"
                 }
               }
             }
           } =
             WorldServiceTopicsRedirect.call(%Envelope{
               request: %Envelope.Request{
                 path: "/pidgin/topics/cqywjyzk2vyt/page/5",
                 path_params: %{"page" => "5", "id" => "cqywjyzk2vyt"}
               }
             })
  end

  test "redirects old to base of new ws topics page - w/ variant" do
    assert {
             :stop,
             %Belfrage.Envelope{
               response: %Belfrage.Envelope.Response{
                 http_status: 302,
                 body: "Redirecting",
                 headers: %{
                   "location" => "/serbian/cyr/topics/cqwvxvvw9qrt",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, max-age=60"
                 }
               }
             }
           } =
             WorldServiceTopicsRedirect.call(%Envelope{
               request: %Envelope.Request{
                 path: "/serbian/cyr/topics/cqwvxvvw9qrt/page/5",
                 path_params: %{"page" => "5", "id" => "cqwvxvvw9qrt"}
               }
             })
  end
end
