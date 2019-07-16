defmodule Belfrage.ServiceProvider do
  alias Belfrage.{Services, Behaviours.ServiceProvider}

  @behaviour ServiceProvider

  @impl ServiceProvider
  def service_for(origin) do
    cond do
      origin =~ ~r[^http(s)?://] -> Services.HTTP
      true -> Services.Webcore
    end
  end
end
