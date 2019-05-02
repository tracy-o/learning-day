defmodule Ingress.ServiceProviderMock do
  alias Ingress.{Services, Behaviours.ServiceProvider}

  @behaviour ServiceProvider

  @impl ServiceProvider
  def service_for(_origin) do
    Services.ServiceMock
  end
end