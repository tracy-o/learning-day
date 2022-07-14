defmodule Belfrage.Clients.HTTP do
  @moduledoc """
  Calls 3rd party http clients to make requests.

  Makes requests and formats responses using Belfrage's
  own HTTP Request, Response and Error structs.
  """
  alias Belfrage.{Clients.HTTP, Metrics.Statix, Event}
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
    if pool_group in [:OriginSimulator, :Programmes, :Simorgh, :Fabl] do
      Finch.build(
        request.method,
        request.url,
        Enum.into(request.headers, []),
        request.payload
      )
      |> FinchAPI.request(
        Finch,
        receive_timeout: request.timeout,
        pool_timeout: finch_pool_timeout()
      )
    else
      @machine_gun.request(
        request.method,
        request.url,
        request.payload,
        Enum.into(request.headers, []),
        build_options(request, pool_group)
      )
    end
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

  defp format_response({:ok, finch_response = %Finch.Response{}}) do
    {:ok,
     HTTP.Response.new(%{
       status_code: finch_response.status,
       body: finch_response.body,
       headers: finch_response.headers
     })}
  end

  defp format_response({:error, error}) do
    {:error, HTTP.Error.new(error)}
  end

  defp metric_response(response) do
    case response do
      {:error, %MachineGun.Error{reason: :pool_timeout}} ->
        Statix.increment("http.pools.error.timeout", 1, tags: Event.global_dimensions())
        response

      {:error, %MachineGun.Error{reason: :pool_full}} ->
        Statix.increment("http.pools.error.full", 1, tags: Event.global_dimensions())
        response

      {:error, %MachineGun.Error{reason: _error}} ->
        Statix.increment("http.client.error", 1, tags: Event.global_dimensions())
        response

      _ ->
        response
    end
  end

  defp finch_pool_timeout() do
    Application.get_env(:finch, :pool_timeout)
  end
end
