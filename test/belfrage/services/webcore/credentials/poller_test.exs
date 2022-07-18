defmodule Belfrage.Services.Webcore.Credentials.PollerTest do
  # Can't be async because it updates the state of Webcore.Credentials which is
  # a global resource
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [wait_for: 1]

  alias Belfrage.Services.Webcore.Credentials
  alias Belfrage.Services.Webcore.Credentials.Poller
  alias Belfrage.{AWS, AWSMock}

  @some_creds %AWS.Credentials{
    session_token: "some-session-token",
    access_key_id: "some-access-key-id",
    secret_access_key: "some-secret-access-key"
  }

  @some_other_creds %AWS.Credentials{
    session_token: "some-other-session-token",
    access_key_id: "some-other-access-key-id",
    secret_access_key: "some-other-secret-access-key"
  }

  test "periodically gets credentials from configured source and updates Webcore.Credentials" do
    assert %AWS.Credentials{access_key_id: nil, secret_access_key: nil, session_token: nil} == Credentials.get()

    expect(AWSMock, :request, fn _request ->
      {:ok, %{body: Map.from_struct(@some_creds)}}
    end)

    start_supervised!(Poller)

    wait_for(fn -> Credentials.get() == @some_creds end)

    expect(AWSMock, :request, fn _request ->
      {:ok, %{body: Map.from_struct(@some_other_creds)}}
    end)

    wait_for(fn -> Credentials.get() == @some_other_creds end)
  end
end
