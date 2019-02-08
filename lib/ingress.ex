defmodule Ingress do
  alias Ingress.HTTPClient

  @origin Application.get_env(:ingress, :origin)

  def handle(service) do
    env = Application.get_env(:ingress, :env)
    HTTPClient.get(@origin, service, env)
  end

  def handle(role, function_name, function_payload) do
    InvokeLambda.invoke(function_name, %{
      role: role,
      function_payload: function_payload
    })
  end
end
