defmodule Belfrage.Services.Webcore.Credentials.Env do
  @moduledoc """
  This module gets the credentials for accessing the Webcore lambda from the
  configuration. It can be used e.g. during development to read the credentials
  for accessing the Webcore lambda from ENV variables (instead of getting them
  from AWS which is what happens in deployments).
  """

  alias Belfrage.AWS

  def get() do
    {:ok,
     %AWS.Credentials{
       access_key_id: Application.fetch_env!(:belfrage, :webcore_credentials_access_key_id),
       secret_access_key: Application.fetch_env!(:belfrage, :webcore_credentials_secret_access_key),
       session_token: Application.fetch_env!(:belfrage, :webcore_credentials_session_token)
     }}
  end
end
