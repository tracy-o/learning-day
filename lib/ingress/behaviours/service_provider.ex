defmodule Ingress.Behaviours.ServiceProvider do
  alias Ingress.Behaviours.Service
  @callback service_for(String.t()) :: Service
end