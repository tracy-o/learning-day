defmodule Belfrage.Services.Webcore.CredentialsTest do
  use ExUnit.Case

  alias Belfrage.Services.Webcore.Credentials
  alias Belfrage.AWS

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
