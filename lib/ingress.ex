defmodule Ingress do
  alias Ingress.HTTPClient

  @origin Application.get_env(:ingress, :origin)

  def handle(service) do
    env = Application.get_env(:ingress, :env)
    HTTPClient.get(@origin, service, env)
  end

  def handle(ec2_role, lambda_role, function_name, function_payload) do
    InvokeLambda.invoke(function_name, %{
      ec2_role:         ec2_role,
      lambda_role:      lambda_role,
      function_payload: function_payload
    })
  end
end
