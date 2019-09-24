defmodule Belfrage.Clients.HTTP do
  @type request_type :: :get | :post

  @callback request(:get, String.t()) :: MachineGun.Response
  @callback request(:get, String.t(), Keyword.t()) :: MachineGun.Response

  @callback request(:post, String.t(), String.t(), Map.t()) :: MachineGun.Response
  @callback request(:post, String.t(), String.t(), Map.t(), List.t()) :: MachineGun.Response

  @timeout 10_000

  def request(:get, url, options \\ []) do
    request(:get, url, "", options)
  end

  def request(method, url, body, options) do
    headers = Keyword.get(options, :headers, [])
    MachineGun.request(method, url, body, headers, build_options(options))
  end

  def build_options(options) do
    #Keyword.merge([protocols: [:http1], timeout: @timeout], options)
    %{}
  end
end
