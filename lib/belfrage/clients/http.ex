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
  @callback execute(HTTP.Request.t(), Atom) :: {:ok, HTTP.Response.t()} | {:error, HTTP.Error.t()}

  def execute(request = %HTTP.Request{}) do
    execute(request, :default)
  end

  def execute(request = %HTTP.Request{}, pool_group) do
    request
    |> perform_request(pool_group)
    |> metric_response()
    |> format_response()
  end

  defp perform_request(request = %HTTP.Request{}, pool_group) do
    @machine_gun.request(
      request.method,
      request.url,
      request.payload,
      Enum.into(request.headers, []),
      build_options(request, pool_group)
    )
  end

  @doc """
  Build the options, as MachineGun wants them.
  Most of the options are configured in the application
  config, rather than for each request.
  """
  def build_options(request = %HTTP.Request{}, pool_group) do
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

  defp metric_response(response) do
    case response do
      {:error, %MachineGun.Error{reason: :pool_timeout}} ->
        Belfrage.Metrics.Statix.increment("http.pools.error.timeout")
        response

      {:error, %MachineGun.Error{reason: :pool_full}} ->
        Belfrage.Metrics.Statix.increment("http.pools.error.full")
        response

      {:error, %MachineGun.Error{reason: _error}} ->
        Belfrage.Metrics.Statix.increment("http.client.error")
        response

      _ ->
        response
    end
  end
end
