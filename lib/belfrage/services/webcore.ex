defmodule Belfrage.Services.Webcore do
  alias Belfrage.{Clients, Struct}
  alias Belfrage.Services.Webcore
  alias Belfrage.Behaviours.Service

  @behaviour Service

  @xray Application.get_env(:belfrage, :xray)
  @lambda_client Application.get_env(:belfrage, :lambda_client, Clients.Lambda)

  @impl Service
  def dispatch(struct) do
    Struct.add(
      struct,
      :response,
      build_webcore_response(struct)
    )
  end

  defp build_webcore_response(struct) do
    @xray.subsegment_with_struct_annotations("webcore-service", struct, fn ->
      @lambda_client.call(
        arn(struct),
        struct.private.origin,
        Webcore.Request.build(struct),
        invoke_lambda_options(struct)
      )
      |> Webcore.Response.build()
    end)
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
