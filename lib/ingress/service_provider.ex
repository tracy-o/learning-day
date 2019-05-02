defmodule Ingress.ServiceProvider do
  alias Ingress.{Services}

  @http_service Application.get_env(:ingress, :http_service, Services.HTTP)
  @lamdba_service Application.get_env(:ingress, :lambda_service, Services.Lambda)

  def service_for(origin) do
    case origin =~ ~r/^(https)/ do
      true  -> @http_service
      false -> @lamdba_service
    end
  end
end