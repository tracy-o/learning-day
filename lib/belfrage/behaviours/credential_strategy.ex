defmodule Belfrage.Behaviours.CredentialStrategy do
  @type arn :: String.t()
  @type session_name :: String.t()
  @type credentials :: %{
          session_token: String.t(),
          access_key_id: String.t(),
          secret_access_key: String.t()
        }

  @callback refresh_credential(arn, session_name) ::
              {:ok, arn, session_name, credentials} | {:error, :failed_to_fetch_credentials}
end
