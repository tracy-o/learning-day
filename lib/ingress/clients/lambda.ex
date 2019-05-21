defmodule Ingress.Clients.Lambda do
  use ExMetrics

  @callback call_lambda(String.t(), String.t(), String.t(), Ingress.Struct.Request.t()) ::
              Tuple.t()

  def call_lambda(role_name, arn, function, request) do
    ExMetrics.timeframe "function.timing.service.lambda.invoke" do
      {:ok, %{body: credentials}} =
        ExAws.STS.assume_role(arn, role_name)
        |> ExAws.request()

      ExAws.Lambda.invoke(function, request, %{})
      |> ExAws.request(
        security_token: credentials.session_token,
        access_key_id: credentials.access_key_id,
        secret_access_key: credentials.secret_access_key
      )
    end
  end
end
