defmodule Ingress do
  alias Ingress.{HTTPClient, Loop, LoopsRegistry}

  def handle(service) do
    env = Application.get_env(:ingress, :env)

    LoopsRegistry.find_or_start(service)

    {:ok, state} = Loop.state(service)

    {:ok, resp} = HTTPClient.get(state.origin, service, env)
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
