defmodule Belfrage.RequestTransformers.ThreeItemsRedirectTest do
  use ExUnit.Case
  use Test.Support.Helper, :mox

  alias Belfrage.RequestTransformers.ThreeItemsRedirect
  alias Belfrage.Envelope

  import Fixtures.Envelope

  test "If :id in /bbcthree/item/:id matches a guid to be redirected as a clip, a redirect is issued to the corresponding clip page" do
    envelope =
      request_envelope(:https, "www.bbc.co.uk", "/bbcthree/item/febba241-7d72-4869-94b4-b4eba3fb7840", %{}, %{
        "id" => "febba241-7d72-4869-94b4-b4eba3fb7840"
      })

    assert {:stop,
            %Envelope{
              response: %Envelope.Response{
                http_status: 301,
                headers: %{
                  "location" => "/bbcthree/clip/febba241-7d72-4869-94b4-b4eba3fb7840",
                  "x-bbc-no-scheme-rewrite" => "1",
                  "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                },
                body: ""
              }
            }} = ThreeItemsRedirect.call(envelope)
  end

  test "If :id in /bbcthree/item/:id does not match a guid to be redirected as a clip, a redirect is issued to the corresponding article page" do
    envelope =
      request_envelope(:https, "www.bbc.co.uk", "/bbcthree/article/00000000-0000-0000-0000-000000000000", %{}, %{
        "id" => "00000000-0000-0000-0000-000000000000"
      })

    assert {:stop,
            %Envelope{
              response: %Envelope.Response{
                http_status: 301,
                headers: %{
                  "location" => "/bbcthree/article/00000000-0000-0000-0000-000000000000",
                  "x-bbc-no-scheme-rewrite" => "1",
                  "cache-control" => "public, stale-while-revalidate=10, max-age=60"
                },
                body: ""
              }
            }} = ThreeItemsRedirect.call(envelope)
  end
end
