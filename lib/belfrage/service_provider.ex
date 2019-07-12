defmodule Belfrage.ServiceProvider do
  alias Belfrage.{Services, Behaviours.ServiceProvider}

  @behaviour ServiceProvider

  @impl ServiceProvider
  def service_for(origin) do
    cond do
      origin =~ ~r[service-worker.js$] -> Services.Lambda.ServiceWorker
      origin =~ ~r[graphql] -> Services.Lambda.Graphql
      origin =~ ~r[^http(s)?://] -> Services.HTTP
      true -> Services.Lambda.Pwa
    end
  end
end
