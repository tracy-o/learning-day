defmodule Belfrage.Behaviours.ServiceProvider do
  @callback service_for(String.t()) :: Belfrage.Behaviours.Service
end
