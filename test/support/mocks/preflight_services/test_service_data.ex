defmodule Belfrage.PreflightServices.TestServiceData do
  alias Belfrage.Behaviours.PreflightService
  alias Belfrage.Envelope
  @behaviour PreflightService

  @impl PreflightService
  def request(%Envelope{request: %Envelope.Request{path: path}}) do
    %{
      method: :get,
      url: path,
      timeout: 500
    }
  end

  @impl PreflightService
  def cache_key(%Envelope{request: %Envelope.Request{path: path}}) do
    path
  end

  @impl PreflightService
  def handle_response(%{"data" => data}), do: {:ok, data}
  def handle_response(_response), do: {:error, :preflight_data_error}
end
