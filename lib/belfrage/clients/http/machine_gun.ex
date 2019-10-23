defmodule Belfrage.Clients.HTTP.MachineGun do
  @moduledoc """
  `Mox`able abstraction module for Machine gun.
  """
  @type method :: :get | :post
  @type payload :: String.t()
  @type url :: String.t()
  @type headers :: list()
  @type options :: map()
  @callback request(method, url, payload, headers, options) ::
              {:ok, MachineGun.Response.t()} | {:error, MachineGun.Error.t()}

  defdelegate request(method, url, payload, headers, options), to: MachineGun, as: :request
end
