defmodule Ingress.Handler do
  alias Ingress.HTTPClient

  @origin Application.get_env(:ingress, :origin)

  def handle(service) do
    env = Application.get_env(:ingress, :env)
    HTTPClient.get(@origin, service, env)
  end
end
