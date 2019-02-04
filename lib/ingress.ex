defmodule Ingress do
  alias Ingress.{HTTPClient, Guardian}

  @origin Application.get_env(:ingress, :origin)

  def handle(service) do
    env = Application.get_env(:ingress, :env)
    {:ok ,origin} = Guardian.origin(:guardian)

    {:ok, resp} = HTTPClient.get(origin, service, env)
    Guardian.inc(:guardian, resp.status_code)

    resp.body
  end

  def handle(instance_role_name, lambda_role_arn, function_name, function_payload) do
    InvokeLambda.invoke(function_name, %{
      instance_role_name: instance_role_name,
      lambda_role_arn: lambda_role_arn,
      function_payload: function_payload
    })
  end
end
