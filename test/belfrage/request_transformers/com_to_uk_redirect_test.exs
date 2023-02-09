defmodule Belfrage.RequestTransformers.ComToUKRedirectTest do
  use ExUnit.Case, async: true
  import Fixtures.Envelope

  alias Belfrage.RequestTransformers.ComToUKRedirect

  test "redirect to co.uk when host is .com" do
    envelope = request_envelope(:https, "www.bbc.com", "/search")

    assert {
             :stop,
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
           } = ComToUKRedirect.call(envelope)
  end

  test "redirect to co.uk with the correct subdomain" do
    envelope = request_envelope(:https, "sub.domain.bbc.com", "/search")

    assert {
             :stop,
             %{response: %{http_status: 302, headers: %{"location" => "https://sub.domain.bbc.co.uk/search"}}}
           } = ComToUKRedirect.call(envelope)
  end

  test "redirect to co.uk including query params" do
    envelope = request_envelope(:https, "www.bbc.com", "/search", %{"q" => "ruby", "page" => "3"})

    assert {
             :stop,
             %{response: %{http_status: 302, headers: %{"location" => "https://www.bbc.co.uk/search?page=3&q=ruby"}}}
           } = ComToUKRedirect.call(envelope)
  end

  test "redirect to co.uk without changing scheme" do
    envelope = request_envelope(:http, "www.bbc.com", "/search")

    assert {
             :stop,
             %{response: %{http_status: 302, headers: %{"location" => "http://www.bbc.co.uk/search"}}}
           } = ComToUKRedirect.call(envelope)
  end

  test "redirect only when host is bbc.com" do
    envelope = request_envelope(:https, "www.bbc.co.uk", "/search")

    assert {
             :ok,
             %{response: %{http_status: nil, body: "", headers: %{}}}
           } = ComToUKRedirect.call(envelope)
  end
end
