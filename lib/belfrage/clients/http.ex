defmodule Belfrage.Clients.HTTP do
  @moduledoc """
  Calls 3rd party http clients to make requests.

  Makes requests and formats responses using Belfrage's
  own HTTP Request, Response and Error structs.
  """
  alias Belfrage.Clients.HTTP
  import Belfrage.Metrics.LatencyMonitor, only: [checkpoint: 2]
  @machine_gun Application.get_env(:belfrage, :machine_gun)

  @type request_type :: :get | :post
  @callback execute(HTTP.Request.t()) :: {:ok, HTTP.Response.t()} | {:error, HTTP.Error.t()}
  @callback execute(HTTP.Request.t(), Atom) :: {:ok, HTTP.Response.t()} | {:error, HTTP.Error.t()}

  def execute(request = %HTTP.Request{}) do
    execute(request, :default)
  end

  def execute(request = %HTTP.Request{}, pool_group) do
    latency_checkpoint(request, :request_end)

    response =
      @machine_gun.request(
        request.method,
        request.url,
        request.payload,
        machine_gun_headers(request.headers),
        build_options(request, pool_group)
      )

    latency_checkpoint(request, :response_start)

    format_response(response)
  end

  defp latency_checkpoint(%HTTP.Request{request_id: rid}, _name) when is_nil(rid), do: :noop
  defp latency_checkpoint(%HTTP.Request{request_id: rid}, name), do: checkpoint(rid, name)

  defp machine_gun_headers(headers) do
    headers
    |> Enum.into([])
  end

  @doc """
  Build the options, as MachineGun wants them.
  Most of the options are configured in the application
  config, rather than for each request.
  """
  def build_options(request, pool_group) do
    %{request_timeout: request.timeout, pool_group: pool_group}
  end

  defp format_response({:ok, machine_response = %MachineGun.Response{}}) do
    {:ok,
     HTTP.Response.new(%{
       status_code: machine_response.status_code,
       body: machine_response.body,
       headers: machine_response.headers
     })}
  end

  defp format_response({:error, error = %MachineGun.Error{}}) do
    {:error, HTTP.Error.new(error)}
  end
end
