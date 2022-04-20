defmodule Belfrage.Authentication.JWK.PollerTest do
  # Can't be async because it updates the state of Belfrage.Authentication.JWK
  # which is a global resource
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [wait_for: 1]

  alias Belfrage.Authentication.JWK
  alias Belfrage.Authentication.JWK.Poller
  alias Belfrage.Clients.{HTTP, HTTPMock}

  test "fetches and updates JWK keys from the API" do
    assert JWK.get("foo", "bar") == {:error, :public_key_not_found}

    expect(HTTPMock, :execute, fn _, _origin ->
      payload = "{\"keys\": [{\"alg\": \"foo\", \"kid\": \"bar\"}]}"
      {:ok, %HTTP.Response{status_code: 200, body: payload}}
    end)

    start_supervised!({Poller, interval: 0, name: :test_jwk_poller})
    wait_for(fn -> JWK.get("foo", "bar") |> elem(0) == :ok end)

    expect(HTTPMock, :execute, fn _, _origin ->
      payload = "{\"keys\": []}"
      {:ok, %HTTP.Response{status_code: 200, body: payload}}
    end)

    wait_for(fn -> JWK.get("foo", "bar") == {:error, :public_key_not_found} end)
  end
end
