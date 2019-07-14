defmodule Belfrage.ServiceProvider do
  alias Belfrage.{Services, Behaviours.ServiceProvider}

  @behaviour ServiceProvider

  @impl ServiceProvider
  def service_for(origin) do
    cond do
      origin =~ ~r[service-worker.js$] -> Services.Webcore.ServiceWorker
      origin =~ ~r[graphql] -> Services.Webcore.Graphql
      origin =~ ~r[^http(s)?://] -> Services.HTTP
      true -> Services.Webcore.Pwa
    end
  end
end
