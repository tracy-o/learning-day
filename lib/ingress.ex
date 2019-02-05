defmodule Ingress do
  alias Ingress.HTTPClient

  @origin Application.get_env(:ingress, :origin)

  def handle(service) do
    env = Application.get_env(:ingress, :env)
    HTTPClient.get(@origin, service, env)
  end

  def handle(service, body) do
    env = Application.get_env(:ingress, :env)
    HTTPClient.post(@origin, service, env, body)
  end
end
