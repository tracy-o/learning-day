defmodule Belfrage.Credentials.LocalDev do
  @behaviour Belfrage.Behaviours.CredentialFetcher

  @impl true
  def refresh_credential(arn, session_name) do
    Stump.log(:warn, %{
      msg: "Not fetching credentials in dev mode"
    })
    {:error, :failed_to_fetch_credentials}
  end
end