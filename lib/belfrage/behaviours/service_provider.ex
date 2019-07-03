defmodule Ingress.Behaviours.ServiceProvider do
  @callback service_for(String.t()) :: Ingress.Behaviours.Service
end
