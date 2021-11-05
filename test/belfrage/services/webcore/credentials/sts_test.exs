defmodule Belfrage.Services.Webcore.Credentials.STSTest do
  use ExUnit.Case, async: true
  use Test.Support.Helper, :mox

  alias Belfrage.Services.Webcore.Credentials.STS
  alias Belfrage.AWS
  alias Belfrage.AWSMock

  describe "get/0" do
    test "assumes configured role to retrieve credentials" do
      expect(AWSMock, :request, fn request ->
        assert request.action == :assume_role
        assert request.params["RoleArn"] == Application.get_env(:belfrage, :webcore_lambda_role_arn)
        assert request.params["RoleSessionName"] == "webcore_session"

        {:ok,
         %{
           body: %{
             access_key_id: "sts-access-key-id",
             secret_access_key: "sts-secret-access-key",
             session_token: "sts-session-token"
           }
         }}
      end)

      {:ok, credentials = %AWS.Credentials{}} = STS.get()
      assert credentials.access_key_id == "sts-access-key-id"
      assert credentials.secret_access_key == "sts-secret-access-key"
      assert credentials.session_token == "sts-session-token"
    end

    test "returns error on receiving HTTP error from AWS" do
      stub(AWSMock, :request, fn _request ->
        {:error, {:http, 500, "Boom"}}
      end)

      assert STS.get() == {:error, :failed_to_fetch_credentials}
    end

    test "returns error on receiving any other error AWS" do
      stub(AWSMock, :request, fn _request ->
        {:error, :something_went_wrong}
      end)

      assert STS.get() == {:error, :failed_to_fetch_credentials}
    end
  end
end
