defmodule Belfrage.Credentials.LocalDev do
  @behaviour Belfrage.Behaviours.CredentialStrategy

  @impl true
  def refresh_credential(arn, session_name) do
    credentials = %{
      session_token: Application.fetch_env!(:belfrage, :session_token),
      access_key_id: Application.fetch_env!(:belfrage, :access_key_id),
      secret_access_key: Application.fetch_env!(:belfrage, :secret_access_key)
    }

    case credentials.session_token do
      nil ->
        Stump.log(:error, %{msg: "Local credentials not found"})
        {:error, :failed_to_fetch_credentials}
      _ -> {:ok, arn, session_name, credentials}
    end
  end
end
