defmodule Belfrage.Services.Webcore.CredentialsTest do
  use ExUnit.Case, async: true

  alias Belfrage.Services.Webcore.Credentials
  alias Belfrage.AWS

  test "gets the credentials from the configured source on startup" do
    {:ok, credentials} = Application.get_env(:belfrage, :webcore_credentials_source).get()
    pid = start_supervised!({Credentials, name: :test_webcore_credentials})
    assert Credentials.get(pid) == credentials
  end

  describe "update/1" do
    test "updates the credentials" do
      pid = start_supervised!({Credentials, name: :test_webcore_credentials})
      credentials = %AWS.Credentials{session_token: "foo"}
      refute Credentials.get(pid) == credentials

      Credentials.update(pid, credentials)
      assert Credentials.get(pid) == credentials
    end
  end
end
