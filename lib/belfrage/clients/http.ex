defmodule Belfrage.Clients.HTTP do
  @moduledoc """
  Calls 3rd party http clients to make requests.

  Makes requests and formats responses using Belfrage's
  own HTTP Request, Response and Error structs.
  """
  alias Belfrage.Clients.HTTP
  @machine_gun Application.get_env(:belfrage, :machine_gun)

  @type request_type :: :get | :post
  @callback execute(HTTP.Request.t()) :: {:ok, HTTP.Response.t()} | {:error, HTTP.Error.t()}

  def execute(request = %HTTP.Request{}) do
    @machine_gun.request(request.method, request.url, request.payload, machine_gun_headers(request.headers), build_options(request))
    |> format_response()
  end

  defp machine_gun_headers(headers) do
    headers
    |> Enum.into([])
  end

  @doc """
  Build the options, as MachineGun wants them.
  Most of the options are configured in the application
  config, rather than for each request.
  """
  def build_options(request) do
    %{request_timeout: request.timeout}
  end

  defp format_response({:ok, machine_response = %MachineGun.Response{}}) do
    {:ok, HTTP.Response.new(%{
      status_code: machine_response.status_code,
      body: machine_response.body,
      headers: machine_response.headers
    })}
  end

  defp format_response({:error, %MachineGun.Error{reason: reason}}) do
    {:error, HTTP.Error.new(reason)}
  end
end
