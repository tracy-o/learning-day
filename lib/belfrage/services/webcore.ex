defmodule Belfrage.Services.Webcore do
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Services.Webcore
  alias Belfrage.Behaviours.Service

  @behaviour Service

  @lambda_client Application.get_env(:belfrage, :lambda_client, Clients.Lambda)

  @impl Service
  def dispatch(struct = %Struct{private: private}) do
    Struct.add(
      struct,
      :response,
      build_webcore_response(struct)
    )
  end

  defp arn(_) do
    Application.fetch_env!(:belfrage, :webcore_lambda_role_arn)
  end

  defp invoke_lambda_options(%Struct{request: %Struct.Request{xray_trace_id: nil}}) do
    []
  end

  defp invoke_lambda_options(%Struct{request: %Struct.Request{xray_trace_id: xray_trace_id}}) do
    [xray_trace_id: xray_trace_id]
  end
end
