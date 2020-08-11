defmodule Belfrage.Transformers.ComToUKRedirectTest do
  use ExUnit.Case, async: true
  import Fixtures.Struct

  alias Belfrage.Transformers.ComToUKRedirect

  test "redirect to co.uk when host is .com" do
    struct = request_struct(:https, "www.bbc.com", "/search")

    assert {
             :redirect,
             %{
               response: %{
                 http_status: 302,
                 body: "Redirecting",
                 headers: %{
                   "location" => "https://www.bbc.co.uk/search",
                   "x-bbc-no-scheme-rewrite" => "1",
                   "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                 }
               }
             }
           } = ComToUKRedirect.call([], struct)
  end

  test "redirect to co.uk with the correct subdomain" do
    struct = request_struct(:https, "sub.domain.bbc.com", "/search")

    assert {
             :redirect,
             %{response: %{http_status: 302, headers: %{"location" => "https://sub.domain.bbc.co.uk/search"}}}
           } = ComToUKRedirect.call([], struct)
  end

  test "redirect to co.uk including query params" do
    struct = request_struct(:https, "www.bbc.com", "/search", %{"q" => "ruby", "page" => "3"})

    assert {
             :redirect,
             %{response: %{http_status: 302, headers: %{"location" => "https://www.bbc.co.uk/search?page=3&q=ruby"}}}
           } = ComToUKRedirect.call([], struct)
  end

  test "redirect to co.uk without changing scheme" do
    struct = request_struct(:http, "www.bbc.com", "/search")

    assert {
             :redirect,
             %{response: %{http_status: 302, headers: %{"location" => "http://www.bbc.co.uk/search"}}}
           } = ComToUKRedirect.call([], struct)
  end

  test "redirect only when host is bbc.com" do
    struct = request_struct(:https, "www.bbc.co.uk", "/search")

    assert {
             :ok,
             %{response: %{http_status: nil, body: "", headers: %{}}}
           } = ComToUKRedirect.call([], struct)
  end
end
