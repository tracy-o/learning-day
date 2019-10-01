defmodule Belfrage.Clients.HTTP do
  @moduledoc """
  Abstracts 3rd party http clients.

  Makes requests and formats responses using Belfrage's
  own HTTP Request, Response and Error structs.
  """
  alias Belfrage.Clients.HTTP
  @type request_type :: :get | :post

  @callback execute(HTTP.Request.t()) :: {:ok, HTTP.Response.t()} | {:error, HTTP.Error.t()}

  def execute(request = %HTTP.Request{}) do
    MachineGun.request(request.method, request.url, request.payload, request.headers, build_options(request))
    |> format_response()
  end

  @doc """
  Build the options, as MachineGun wants them
  """
  def build_options(request) do
    %{request_timeout: request.timeout}
  end

  defp format_response({:ok, machine_response = %MachineGun.Response{}}) do
    {:ok, %HTTP.Response{
      status_code: machine_response.status_code,
      body: machine_response.body,
      headers: machine_response.headers
    }}
  end

  defp format_response({:error, %MachineGun.Error{reason: reason}}) do
    {:error, HTTP.Error.new(reason)}
  end
end
