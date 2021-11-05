defmodule Belfrage.Services.Webcore.Credentials.PollerTest do
  # Can't be async because it updates the state of Webcore.Credentials which is
  # a global resource
  use ExUnit.Case
  use Test.Support.Helper, :mox
  import Test.Support.Helper, only: [wait_for: 1]

  alias Belfrage.Services.Webcore.Credentials
  alias Belfrage.Services.Webcore.Credentials.{Poller, STS}
  alias Belfrage.{AWS, AWSMock}

  test "periodically gets credentials from configured source and updates Webcore.Credentials" do
    original_creds = Credentials.get()

    on_exit(fn ->
      Credentials.update(original_creds)
    end)

    stub_aws(
      {:ok,
       %{
         body: %{
           access_key_id: "poller-access-key-id",
           secret_access_key: "poller-secret-access-key",
           session_token: "poller-session-token"
         }
       }}
    )

    refute original_creds.access_key_id == "poller-access-key-id"
    refute original_creds.secret_access_key == "poller-secret-access-key"
    refute original_creds.session_token == "poller-session-token"

    start_supervised({Poller, source: STS, interval: 0, name: :test_webcore_credentials_poller})

    expected_creds = %AWS.Credentials{
      access_key_id: "poller-access-key-id",
      secret_access_key: "poller-secret-access-key",
      session_token: "poller-session-token"
    }

    wait_for(fn -> Credentials.get() == expected_creds end)
  end

  defp stub_aws(response) do
    stub(AWSMock, :request, fn _ -> response end)
  end
end
