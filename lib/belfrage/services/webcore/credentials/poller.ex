defmodule Belfrage.Services.Webcore.Credentials.Poller do
  @moduledoc """
  This module periodically gets the credentials for calling the Webcore lambda
  from the configured source and updates them in
  `Belfrage.Services.Webcore.Credentials` process.
  """

  use Belfrage.Poller, interval: Application.get_env(:belfrage, :poller_intervals)[:credentials]

  alias Belfrage.Services.Webcore.Credentials

  @impl Belfrage.Poller
  def poll() do
    source = Application.get_env(:belfrage, :webcore_credentials_source)

    with {:ok, credentials} <- source.get() do
      Credentials.update(credentials)
    end

    :ok
  end
end
