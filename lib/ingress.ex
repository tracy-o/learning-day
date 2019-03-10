defmodule Ingress do
  alias Ingress.{HTTPClient, Loop, LoopsRegistry}

  @origin Application.get_env(:ingress, :origin)

  def handle(service) do
    env = Application.get_env(:ingress, :env)

    LoopsRegistry.find_or_start(service)

    {:ok ,origin} = Loop.origin(service)

    {:ok, resp} = HTTPClient.get(origin, service, env)
    Loop.inc(:loop, resp.status_code)

    {:ok, resp}
  end

  def handle(instance_role_name, lambda_role_arn, function_name, function_payload) do
    InvokeLambda.invoke(function_name, %{
      instance_role_name: instance_role_name,
      lambda_role_arn: lambda_role_arn,
      function_payload: function_payload
    })
  end
end
