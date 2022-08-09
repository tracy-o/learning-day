defmodule Belfrage.Clients.HTTP do
  @moduledoc """
  Calls 3rd party http clients to make requests.

  Makes requests and formats responses using Belfrage's
  own HTTP Request, Response and Error structs.
  """
  alias Belfrage.{Clients.HTTP, Event}

  @type request_type :: :get | :post
  @callback execute(HTTP.Request.t()) :: {:ok, HTTP.Response.t()} | {:error, HTTP.Error.t()}
  @callback execute(HTTP.Request.t(), Atom) :: {:ok, HTTP.Response.t()} | {:error, HTTP.Error.t()}

  def execute(request = %HTTP.Request{}), do: do_execute(request)

  def execute(request = %HTTP.Request{}, _pool), do: do_execute(request)

  def do_execute(request = %HTTP.Request{}) do
    request
    |> perform_request()
    |> format_response()
    |> metric_response()
  end

  defp perform_request(request = %HTTP.Request{}) do
    try do
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
    catch
      type, reason -> {:error, {type, reason}}
    end
  end

  @doc """
  Build the options, as Finch wants them.
  Most of the options are configured in the application
  config, rather than for each request.
  """
  def build_options(request = %HTTP.Request{}, pool_group) do
    %{request_timeout: request.timeout, pool_group: pool_group}
  end

  defp format_response({:ok, finch_response = %Finch.Response{}}) do
    {:ok,
     HTTP.Response.new(%{
       status_code: finch_response.status,
       body: finch_response.body,
       headers: finch_response.headers
     })}
  end

  # used when Finch raises an error and is caught
  defp format_response({:error, {error_type, reason}}) when error_type in [:error, :exit, :throw] do
    {:error, HTTP.Error.new(error_type, reason)}
  end

  # used when Finch itself returns an {:error, reason} tuple
  defp format_response({:error, error}) do
    {:error, HTTP.Error.new(error)}
  end

  defp metric_response(response) do
    case response do
      {:error, %HTTP.Error{reason: :pool_timeout}} ->
        :telemetry.execute([:belfrage, :http, :pools, :error, :timeout], %{count: 1})
        response

      {:error, %HTTP.Error{reason: _reason}} ->
        :telemetry.execute([:belfrage, :http, :client, :error], %{count: 1})
        response

      _ ->
        response
    end
  end

  defp finch_pool_timeout() do
    Application.get_env(:finch, :pool_timeout)
  end
end
